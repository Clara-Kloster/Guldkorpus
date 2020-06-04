# -*- coding:utf-8 -*-
# This program finds all lemmata that are tagged with the various pronoun/determiner tags

import re
import csv
import os
import sys

# Find relative path
sys.path.append(os.path.realpath('../..'))
directory = sys.path[-1] + '/transcriptions/org/working/'

pron_pos = ['xPE', 'xPQ', 'xPI', 'xDP', 'xDD', 'xPD', 'xRP', 'xAT']
pronouns = [ ]

for filename in os.listdir(directory):
    if filename.endswith(".org"):
        working_file = directory + filename
        data = open(working_file).read()
        mo = re.search("Transcription\n.*\n(\n|$)", data, re.S)
        mytable = mo.group(0)
        d = csv.DictReader(mytable.splitlines(), delimiter = '|')
        for row in d:
            if row[None][3].strip() in pron_pos:
                if row[None][2].strip() not in pronouns:
                    pronouns.append(row[None][2].strip())
pronouns.sort()

for pronoun in pronouns:
    print(pronoun)
            
