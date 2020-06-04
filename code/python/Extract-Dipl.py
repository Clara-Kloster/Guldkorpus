# -*- coding:utf-8 -*-
# This program extracts all Danish-language charters dipl-level into single .org file

import re
import csv
import os
import sys

# Find relative path
sys.path.append(os.path.realpath('../..'))
directory = sys.path[-1] + '/transcriptions/org/working/'
metafile = sys.path[-1] + '/documentation/corpus_lists.org'

# Make list of Danish language files
danish = [ ]
metadata = open(metafile).read()
mo = re.search("NAME: Korpusliste\n.*\n(\n|$)", metadata, re.S)
mytable = mo.group(0)
d = csv.DictReader(mytable.splitlines(), delimiter="|")
for row in d:
    try:
        if row[None][8].strip() == "Dansk":
            danish.append(row[None][0].strip())
    except:
        pass
danish.sort()
print("Number of files: " + str(len(danish)))

# Read individual files
write_file = open("/Users/Sean/Documents/Velux/Notes/AllDanish.org", "w+")
for item in danish:
    write_file.write("** " + item + "\n")
    working_file = directory + item + '.org'
    data = open(working_file).read()
    mo = re.search("Transcription\n.*\n(\n|$)", data, re.S)
    mytable = mo.group(0)
    d = csv.DictReader(mytable.splitlines(), delimiter="|")
    for row in d:
        if row[None][0].strip() == "w" or row[None][0].strip() == "n":
            write_file.write(' ' + row[None][6].strip())
        elif row[None][0].strip() == "p":
            write_file.write(row[None][6].strip())
    write_file.write("\n")
write_file.close()
