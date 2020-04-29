# -*- coding: utf-8 -*-

# This program finds all lemmas in org files and prints with filename
import re
import csv
import os
import sys
import xlrd
import plotly

# Check for normalization
if sys.argv[1] == "-n":
    normalize = True
else:
    normalize = False
    

# Find relative path
sys.path.append(os.path.realpath('../..'))
directory = sys.path[-1] + '/transcriptions/org/lemmatisation/' # needs to be fixed to working later
lemmata = []
lemmaTable = { }
attestTable = { }

for filename in os.listdir(directory):
    if filename.endswith(".org"):
        working_file = directory + filename
        shortname = filename.replace(".org","")
        data = open(working_file).read()
        mo = re.search("Transcription\n.*\n(\n|$)", data, re.S)
        mytable = mo.group(0)
        d = csv.DictReader(mytable.splitlines(), delimiter='|')
        for row in d:
            lemma = row[None][2].strip()
            attestation = row[None][6].strip().lower()
            if normalize == True:
                attestation = attestation.replace('j','i').replace('w','v')
            attestation_stripped = re.sub('[^a-zæøA-ZÆØ]', '', attestation)
            if lemma not in lemmata:
                lemmata.append(lemma)
                lemmata.sort()
                lemmaTable[lemma] = [ ]
                attestTable[lemma] = [ ]
            #if shortname not in lemmaTable[lemma]:
            lemmaTable[lemma].append(shortname)
            attestTable[lemma].append(attestation_stripped)
        continue
    else:
        continue

traces = [ ]
xvals = [ ]
yvals = [ ]
colors = [ ]
symbols = [ ]
names = [ ]
if normalize == True:
    lemma = sys.argv[2]
else:
    lemma = sys.argv[1]
dataDoc = xlrd.open_workbook('/Users/Sean/Documents/Velux/Datasheets/Dansk.xlsx')
data = dataDoc.sheet_by_index(1)
date = ''
region = ''
city = ''
attNum = 0
for key in lemmaTable[lemma]:
    attestation = attestTable[lemma][attNum]
    for row in range(1, data.nrows):
        if int(data.cell(row,0).value) == int(key):
            date = int(data.cell(row,2).value)
            region = str(data.cell(row, 4).value)
            city = str(data.cell(row, 3).value.encode('utf-8'))
    if date != 0:
        xvals.append(date)
        yvals.append(attestation)
        names.append(key + " " + city)
        if region == "Zealand":
            colors.append("salmon")
        elif region == "East":
            colors.append("cornflowerblue")
        elif region == "Jutland":
            colors.append("seagreen")
        else:
            colors.append("grey")
        if city == "Roskilde":
            symbols.append("star")
        else:
            symbols.append("circle")
    elif date == 0:
        print (key, date, attestation)
    attNum += 1
trace = plotly.graph_objs.Scatter(
    x = xvals,
    y = yvals,
    text = names,
    mode = 'markers',
    marker = dict(
        color = colors,
        symbol = symbols,
        size = 10
    )
)
traces = [trace]
layout = dict(title = lemma, yaxis=dict(categoryorder = "category descending"))
fig = plotly.graph_objs.Figure(data=traces, layout=layout)
plotly.offline.plot(fig)

