# -*- coding: utf-8 -*-

# This program finds all instances of a given lemma and maps them on a timeline
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
input_directory = sys.path[-1] + '/transcriptions/org/working/'
output_directory = sys.path[-1] + '/code/output/'
metafile = sys.path[-1] + '/documentation/corpus_lists.org'
lemmata = []
lemmaTable = { }
attestTable = { }

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

for item in danish:
    print("Checking file: " + item)
    working_file = input_directory + item + ".org"
    data = open(working_file).read()
    mo = re.search("Transcription\n.*\n(\n|$)", data, re.S)
    print(mo)
    mytable = mo.group(0)
    d = csv.DictReader(mytable.splitlines(), delimiter='|')
    for row in d:
        lemma = row[None][2].strip()
        attestation = row[None][6].strip().lower()
        if normalize == True:
            attestation = attestation.replace('j','i').replace('w','u').replace('ffv','ffu').replace('v','u')
        attestation_stripped = re.sub('[^a-zæøA-ZÆØ]', '', attestation)
        if lemma not in lemmata:
            lemmata.append(lemma)
            lemmata.sort()
            lemmaTable[lemma] = [ ]
            attestTable[lemma] = [ ]
        lemmaTable[lemma].append(item)
        attestTable[lemma].append(attestation_stripped)

print("Total files checked: " + str(len(danish)))
        
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
            city = str(data.cell(row, 3).value)
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
layout = dict(title = lemma, yaxis=dict(categoryorder = "min descending"))
fig = plotly.graph_objs.Figure(data=traces, layout=layout)
if normalize == True:
    file_name = "../output/Lemmata/" + lemma + "_norm.html"
else:
    file_name = "../output/Lemmata/" +lemma + ".html"
plotly.offline.plot(fig, filename=file_name)

