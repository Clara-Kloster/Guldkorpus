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
            pos = row[None][3].strip()
            dipl_unstripped = row[None][6].strip()
            dipl = re.sub(r'[^a-zæøA-ZÆØ]','',dipl_unstripped).lower()
            if lemma not in lemmas:
                lemmas.append(lemma)
                lemmata[lemma] = { }
            if pos not in lemmata[lemma].keys():
                lemmata[lemma][pos] = { }
            if dipl not in lemmata[lemma][pos].keys():
                lemmata[lemma][pos][dipl] = [ ]
            if item not in lemmata[lemma][pos][dipl]:
                lemmata[lemma][pos][dipl].append(item)
                    

lemmas.sort()
lemmas.pop(0)
write_file = open(sys.path[-1] + '/code/output/Lexicon.org', 'w')
write_file.write("#+TITLE: St. Clara Lexicon\n#+OPTIONS: toc:nil\n")
write_file.write("#+LATEX_CLASS_OPTIONS: [a4paper,twocolumn] \n")
write_file.write("#+LATEX_HEADER: \\usepackage{titlesec} \\titleformat{\\section}[runin]{\\bfseries}{}{0.5em}{} \\titlespacing{\\section}{0pt}{2ex}{1ex} \\titleformat{\\subsection}[runin]{}{}{0ex}{} \\titlespacing{\\subsection}{0pt}{1ex}{1ex} \n")
write_file.write("#+LATEX_HEADER: \\usepackage{fancyhdr} \\pagestyle{fancy} \\fancyhf{} \\fancyhead[LE,RO]{Clara Kloster Leksikon} \\fancyfoot[RE,LO]{\\today} \\fancyfoot[LE,RO]{\\thepage} \n")
write_file.write("#+LATEX_HEADER: \\renewcommand\\maketitle{}\n")
for lemma in lemmas:
    print(lemma, lemmata[lemma])
    write_file.write("* " + lemma + "\n")
    for pos in lemmata[lemma].keys():
        write_file.write("** " + pos + "\n")
        attestations = [ ]
        for dipl in lemmata[lemma][pos].keys():
            attestations.append(dipl)
        attestations.sort()
        for item in attestations:
            write_file.write("/" + item + "/ ")
            lemmata[lemma][pos][item].sort()
            for charter in lemmata[lemma][pos][item]:
                write_file.write(charter + " ")
        write_file.write("\n")
    
    
        
