import re


STRING_ROW = 6
LINE_ROW = -1
TAG_ROW = 0
TAG_BE_ROW = 1

class Cell(object):
    def __init__(self, value, space_before, space_after):
        self.value = value
        self.space_before = space_before
        self.space_after = space_after
    
    def update(self, new_value):
        self.value = new_value

    def __str__(self):
        return self.value

    def __len__(self):
        return len(self.value)
    
TAG_ID_ROW = 2

class RowGroup(object):
    def __init__(self, start, end, *contents):
        self.start = start
        self.end = end
        self.contents = [c for c in contents if str(c[TAG_ROW]) in ("w", "p", "n") and str(c[STRING_ROW])]

        # Parse line span
        start_line = ""
        end_line   = ""
        for c in contents:
            line_ref = c[LINE_ROW].value
            if line_ref:
                if not start_line:
                    start_line = line_ref
                end_line = line_ref
        if start_line == end_line:
            self.line_attr = (start_line, )
        else:
            self.line_attr = (start_line, end_line)
        
        # Parse tag id
        start_id = self.start[TAG_ID_ROW].value
        end_id = self.end[TAG_ID_ROW].value
        assert start_id == end_id, "Tagged sequence have non-identical ids ('{}'/'{}')".format(start_id, end_id)
        self.id = start_id
    
    def update_tag_id(self, value):
        self.start[TAG_ID_ROW].update(value)
        self.end[TAG_ID_ROW].update(value)
        self.id = value
    
    def get_tag_id(self):
        return self.start[TAG_ID_ROW].value

    def __iter__(self):
        for row in self.contents:
            yield row

    def __str__(self):
        return " ".join(str(c[STRING_ROW]) for c in self.contents if c[STRING_ROW]) #By default uses col 6 from row (dipl)


class Row(object):
    def __init__(self, columns=[]):
        self.columns = columns

    def __iter__(self):
        for col in self.columns:
            yield col

    def __getitem__(self, item):
        return self.columns[item]

    def __len__(self):
        return len(self.columns)


    def to_string(self, pad_to=False):
        if pad_to: raise NotImplementedError

        return "|"+"|".join([cell.space_before+cell.value+cell.space_after for cell in self.columns])+"|"        

    @classmethod
    def from_string(cls, s):
        cell_pattern = r"(?=(\|)( *)([^\|]*?)( *)(\|))" # i.e., non-inclusive lookfoward
                                                         # with five match groups:
                                                         # 1) cell delimiter, 2) optional space,
                                                         # 3) lazy cell content (zero allowed),
                                                         # 2, 1 repeated

        return cls([Cell(value=match_group[2],
                        space_before=match_group[1],
                        space_after=match_group[3])
            for match_group in re.findall(cell_pattern, s)
        ])
    
    @classmethod
    #TODO: Better default spacing?
    def from_list(cls, L):
        return([Cell(value=l, space_before="", space_after="") for l in L])

class Table(object):
    def __init__(self, rows=[]):
        self.rows = rows

    def validate(self):
        assert len(set([len(row) for row in self.rows])) == 1

    def to_string(self, fixed_columns=False):
        """ Outputs table as string
                `normalise_columns` : Whether columns should have fixed width
        """
        if fixed_columns: raise NotImplementedError

        return "\n".join([row.to_string(pad_to=fixed_columns) for row in self.rows])
    
    def __iter__(self):
        for row in self.rows:
            yield row

    def __getitem__(self, item):
        return self.rows[item]            

    def __len__(self):
        return len(self.rows)

    @classmethod
    def from_lines(cls, lines):
        return cls([Row.from_string(line) for line in lines])


""" Parsers """

def parse_org_transcr(name):
    preamble = ""
    table    = []
    with open(name, "r") as f:
        cue_table = False
        for line in f.readlines():
            
            if not cue_table: preamble += line
            else: table.append(line)

            if line.startswith("*** Transcription"):
                cue_table = True
    table = Table.from_lines(table)                
    return preamble, table


def parse_tags(tag, table, line_offset):

    """
    Identify tagged row sequences in org-tables, where tags are identified
    by rows containing tag type in column <TAG_ROW> and begin/end indicator in
    column <TAG_BE_ROW>. Tags may have id specified by begin and end tags in column
    <TAG_ID_ROW>, which is currently specified while parsing tags RowGroup objects.
    However, the id of tagged sequences may in included during identification,
    as it allows for tags with overlapping edges (see below).

    Specifications
    =======================
    ~~ Overlapping edges ~~
    !__Does not__ support overlapping edges of tags of similar types:
        - tags are closed blindly in an edge-agnostic manner, always closing the latest sequence opened
        - as is, an error will be raised if tags with overlapping edges are supplied with ids
            but the error raised will not be related to edges, but id mismatch
        - if this should be allowed, stack should be popped based on id.
    !__Does__ support overlapping edges of tags with dissimlar types:
        - will not raise an error if resulting tags are overlapping
        - this could be a problem as the resulting orgs are to be converted into xml
            as overlapping edges are will not be well-formed
        - could be tested as a post-process validation step
    """    
    n = line_offset
    
    errors = []
    error_types = {
        ("missing_b") : "[L{}] <{}> misses a begin-tag",
        ("missing_e") : "[L{}] <{}> misses an end-tag",
        ("missing_be") : "[L{}] <{}> misses an star/end indicator",
        ("id_mismatch") : "[LL{}--{}] ",
    }

    tags = [] 
    stack = []

    for i, row in enumerate(table):
        
        # Identify missing begin/end identifier
        if str(row[TAG_ROW]) == tag and str(row[TAG_BE_ROW]) == "":
            errors.append(error_types[("missing_be")].format(i+n, tag))
        
        # Identify begin tag
        elif str(row[TAG_ROW]) == tag and str(row[TAG_BE_ROW]) == "b":
            stack.append([i,])


        # Identify end tag
        elif str(row[TAG_ROW]) == tag and str(row[TAG_BE_ROW]) == "e":

            if not stack:
                errors.append(error_types[("missing_b")].format(i+n, tag))
                continue

            closed_tag = stack.pop()
            closed_tag.append(i)
            tags.append(closed_tag)


        # Tag contents
        else:
            for seq in stack:
                seq.append(i)
        
    if stack:
        for seq in stack:
            errors.append(error_types[("missing_e")].format(seq[0]+n, tag))

    parsed_tags = []
    for seq in tags:
        try:
            row_sequence = [table[i] for i in seq]
            parsed_tags.append(RowGroup(row_sequence[0], row_sequence[-1], *row_sequence[1:-1]))
        except AssertionError as error_message:
            errors.append(error_types[("id_mismatch")].format(seq[0]+n, seq[-1]+n)+str(error_message))


    return tags, parsed_tags, errors