from org import *
import os

def test_tag_completion():

    test_dir = "transcriptions/org/working/"
    test_tags = ("PE", "PL")
    errors = {}

    for transcr in os.listdir(test_dir):
        preamble, table = parse_org_transcr(test_dir+transcr)

        line_offset = len(preamble.split("\n"))

        for tag in test_tags:
            _, error = parse_tags(tag, table, line_offset)
            
            if error:
                if transcr in errors: errors[transcr]+=error
                else: errors[transcr]=error

    raise AssertionError("Found markup errors\n"+"\n".join([doc+":"+"\n- "+"\n- ".join(err)+"\n" for doc, err in errors.items()]))
