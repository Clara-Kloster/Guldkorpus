# -*- coding: utf-8 -*-

# This script compares the character sets of two charters and gives the differences between the two

import re
import csv
import os
import sys

directory = "/Users/Sean/Documents/Guldkorpus/transcriptions/org/working/"

file1 = sys.argv[1]
working_file1 = file1 + '.org'
file2 = sys.argv[2]
working_file2 = file2 + '.org'

glyph_set1 = [ ]
data1 = open(working_file1).read()
mo = re.search("Transcription\n.*\n(\n|$)", data1, re.S)
table1 = mo.group(0)
d1 = csv.DictReader(table1.splitlines(), delimiter='|')
for row in d1:
    if row[None][0].strip() == "w" or row[None][0].strip() == '

