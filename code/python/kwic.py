# -*- coding:utf-8 -*-

# This program makes a KWIC-concordance of a lemma

import re
import csv
import os
import sys

lemma = sys.argv[1]
print("Searching for " + lemma)

if len(sys.argv) > 2:
    length = int(sys.argv[2])
else:
    length = 5

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
for item in danish:
    working_file = directory + item + ".org"
    data = open(working_file).read()
    mo = re.search("Transcription\n.*\n(\n|$)", data, re.S)
    mytable = mo.group(0)
    d = csv.DictReader(mytable.splitlines(), delimiter="|")
    current_row = 1
    wordlist = [ ]
    target_lemma = [ ]
    row_number = 0
    for row in d:
        if row[None][0].strip() == "w" or row[None][0].strip() == "n":
            wordlist.append(row[None][6].strip())
            row_number += 1
        if row[None][2].strip() == lemma:
            target_lemma.append(row_number)
    for target in target_lemma:
        print(str(item))
        print(wordlist[target-length:target+length])
            
