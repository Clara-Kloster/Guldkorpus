import re

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
    

class RowGroup(object):
    def __init__(self, start, end, *contents):
        self.start = start
        self.end = end
        self.contents = contents

        start_line = ""
        end_line   = ""
        for c in contents:
            line_ref = c[-1].value
            if line_ref:
                if not start_line:
                    start_line = line_ref
                end_line = line_ref
        if start_line == end_line:
            self.line_attr = (start_line, )
        else:
            self.line_attr = (start_line, end_line)
    
    def update_tag_cell(self, i, value):
        self.start[i] = value
        self.end[i] = value
    
    def __str__(self):
        return " ".join(str(c[6]) for c in self.contents if c[6]) #By default uses col 6 from row (dipl)


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
    n = line_offset
    
    errors = []
    error_types = {
        ("missing_e", "overlap") : "[L{}] <{}> misses an end-tag or tag overlap occurred",
        ("missing_b") : "[L{}] <{}> misses a begin-tag",
        ("missing_e") : "[L{}] <{}> misses an end-tag"
    }

    tags = [] 
    stack = []
    start_tag = 0

    for i, row in enumerate(table):
        # Identify begin tag
        if str(row[0]) == tag and str(row[1]) == "b":
            
            if stack:
                errors.append(error_types[("missing_e", "overlap")].format(start_tag, tag))

            stack.append(row)
            start_tag = n+i

        # Identify end tag
        elif str(row[0]) == tag and str(row[1]) == "e":

            if not stack:
                errors.append(error_types[("missing_b")].format(n+i, tag))

            stack.append(row)
            tags.append(stack)
            stack = []

        # Tag contents
        else:
            if stack:
                stack.append(row)
        
    if stack:
        errors.append(error_types[("missing_e")].format(start_tag, tag))

    return tags, errors