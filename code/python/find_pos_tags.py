# -*- coding:utf-8 -*-

# This program finds which lemmata have more than on POS tag assigned
import re
import csv
import os
import sys

# Find relative path
sys.path.append(os.path.realpath('../..'))
directory = sys.path[-1] + '/transcriptions/org/lemmatisation/'
lemmata = { }

for filename in os.listdir(directory):
    if filename.endswith(".org"):
        working_file = directory + filename
        data = open(working_file).read()
        mo = re.search("Transcription\n.*\n(\n|$)", data, re.S)
        mytable = mo.group(0)
        d = csv.DictReader(mytable.splitlines(), delimiter = '|')
        for row in d:
            lemma = row[None][2].strip()
            pos = row[None][3].strip()
            if lemma not in lemmata.keys():
                lemmata[lemma] = [ ]
            if pos not in lemmata[lemma]:
                lemmata[lemma].append(pos)

for lemma in lemmata:
    if len(lemmata[lemma]) > 1:
        print("* TODO ",lemma)
        print(lemmata[lemma])
        
