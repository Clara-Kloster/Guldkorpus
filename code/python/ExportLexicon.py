# -*- coding:utf-8 -*-
# This program extracts all lemmata and attestations from the Danish charters

import os
import sys
import re
import csv

# Find relative path
sys.path.append(os.path.realpath('../..'))
input_directory = sys.path[-1] + '/transcriptions/org/working/'
output_directory = sys.path[-1] + '/code/output/'
metafile = sys.path[-1] + '/documentation/corpus_lists.org'

# Make list of Danish language files
danish = [ ]
metadata = open(metafile).read()
mo = re.search("NAME: Korpusliste\n.*\n(\n|$)", metadata, re.S)
mytable = mo.group(0)
d = csv.DictReader(mytable.splitlines(), delimiter = "|")
for row in d:
    try:
        if row[None][8].strip() == "Dansk":
            danish.append(row[None][0].strip())
    except:
        pass
danish.sort()
print("Number of files: " + str(len(danish)))

lemmata = { }
lemmas = [ ]

# Read individual files
for item in danish:
    working_file = input_directory + item + ".org"
    data = open(working_file).read()
    mo = re.search("Transcription\n.*\n(\n|$)", data, re.S)
    mytable = mo.group(0)
    d = csv.DictReader(mytable.splitlines(), delimiter = "|")
    for row in d:
        if row[None][0].strip() == "w":
            lemma = row[None][2].strip()
            if lemma not in lemmas:
                lemmas.append(lemma)
                lemmas.sort()
for item in lemmas:
    print(item)                
        
