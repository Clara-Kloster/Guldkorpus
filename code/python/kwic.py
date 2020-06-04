# -*- coding:utf-8 -*-

# This program makes a KWIC-concordance of a lemma

import re
import csv
import os
import sys
import datetime

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
pos = [ ]
write_file = open(sys.path[-1] + '/code/output/' + lemma + '_kwic.org', 'a')
write_file.write("* Output " + str(datetime.datetime.now()) + ' [/]\n')
for item in danish:
    working_file = directory + item + ".org"
    data = open(working_file).read()
    mo = re.search("Transcription\n.*\n(\n|$)", data, re.S)
    mytable = mo.group(0)
    d = csv.DictReader(mytable.splitlines(), delimiter="|")
    current_row = 1
    wordlist = [ ]
    target_lemma = [ ]
    target_pos = [ ]
    row_number = 0
    for row in d:
        if row[None][0].strip() == "w" or row[None][0].strip() == "n":
            wordlist.append(row[None][6].strip())
            row_number += 1
        if row[None][2].strip() == lemma:
            target_lemma.append(row_number)
            target_pos.append(row[None][3].strip())     
    for target in target_lemma:
        # print(str(item))
        # print(wordlist[target-length:target+length])
        write_file.write("** TODO " + str(item) + " " + target_pos[target_lemma.index(target)] + "\n")
        write_file.write(" ".join(wordlist[target-length:target-1]) + " *" + str(wordlist[target-1]) + "* " + " ".join(wordlist[target:target+length]) + "\n")
        if target_pos[target_lemma.index(target)] not in pos:
            pos.append(target_pos[target_lemma.index(target)])
for item in pos:
    print(item)
