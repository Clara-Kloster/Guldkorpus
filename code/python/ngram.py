# -*- coding:utf-8 -*-
# This code analyzes N-Grams of the lemmata in the Danish charters

import sys
import nltk
from nltk.util import ngrams
from nltk.tokenize import RegexpTokenizer
import pandas as pd
import matplotlib.pyplot as plt
import plotly
import numpy as np
import os
import re
import csv

scope = 20
n = 3

# Find relative paths
sys.path.append(os.path.realpath('../..'))
directory = sys.path[-1] + '/transcriptions/org/lemmatisation/'

print("Reading Files: ", end="")
# The following function reads the texts
def read_files_into_string(filenames):
    strings = [ ]
    for filename in filenames:
        working_file = directory + filename
        data = open(working_file).read()
        mo = re.search("Transcription\n.*\n(\n|$)", data, re.S)
        mytable = mo.group(0)
        d = csv.DictReader(mytable.splitlines(), delimiter="|")
        for row in d:
            if row[None][0].strip() == "w":
                lemma = row[None][2].strip()
                strings.append(lemma)
    return '\n'.join(strings)

texts = { }
files = [ ]
y1400 = [ ]
y1450 = [ ]
y1500 = [ ]
y1550 = [ ]
for filename in os.listdir(directory):
    if filename.endswith(".org"):
        files.append(filename)
        with open(directory + filename, 'r') as this_file:
            for line in this_file:
                if "Year" in line:
                    full_line = line.split()
                    year = full_line[3]
                    if int(year) >= 1400 and int(year) < 1450:
                        y1400.append(filename)
                    elif int(year) >= 1450 and int(year) < 1500:
                        y1450.append(filename)
                    elif int(year) >= 1500 and int(year) < 1550:
                        y1500.append(filename)
                    elif int(year) >= 1550:
                        y1550.append(filename)
texts["all"] = files
texts["y1400"] = y1400
texts["y1450"] = y1450
texts["y1500"] = y1500
texts["y1550"] = y1550

text_types = ["all", "y1400", "y1450", "y1500", "y1550"]
year_types = ["y1400", "y1450", "y1500", "y1550"]

# Half-centuries
# 1400-1449
# 1450-1499
# 1500-1549
# 1550-1599

for text_type, files in texts.items():
    texts[text_type] = read_files_into_string(files)
print("Complete")

# Build Frequency Distributions
print("Building Frequency Distributions: ", end="")
tokens = { 'total' : [ ]}
grams = { 'total' : [ ]}
dist = { 'total' : [ ]}
tokenizer = RegexpTokenizer(r'\w+')
for item in text_types:
    tokens[item] = tokenizer.tokenize(texts[item])
    tokens['total'].extend(tokens[item])
    grams[item] = ngrams(tokens[item], n) # Later: set "2" to "n" and define by user input
    dist[item] = nltk.FreqDist(grams[item])
#    for key, count in dist[item].most_common(20):
#        print(key, count)
        
                
# Graph N-Grams
control = "all"
#for text_group in text_types:
#    x = [ ]
#    for key in dist[control].most_common(scope):
#        label = ""
#        for item in range(0, len(key[0])):
#            label = label + key[0][item] + ' '
#        label = label + ' (' + str(key[1]) + ')'
#        x.append(label)
#    y = [ ]
#    for key in dist[control].most_common(scope):
#        if key[0] in dist[text_group]:
#            frequency = dist[text_group].freq(key[0]) * 100
#        else:
#            frequency = 0
#        y.append(frequency)
#    x = np.array(x)
#    y = np.array(y)
#    plt.plot(x,y,label=text_group)

#plt.legend()
#plt.title("N-Grams")
#plt.ylabel("Frequency (%)")
#plt.xticks(ha="right", rotation = 45)
#plt.tight_layout()
#plt.show()
        
# Attempt to graph backwards
traces = [ ]
for key in dist[control].most_common(20):
    print(key[0])
    x = [ ]
    y = [ ]
    for years in year_types:
        x.append(years)
        if key[0] in dist[years]:
            frequency = dist[years].freq(key[0]) * 100
        else:
            frequency = 0
        y.append(frequency)
    trace = plotly.graph_objs.Scatter(
        x = x,
        y = y,
        name = str(key[0]),
        mode = "lines+markers"
        )
    traces.append(trace)


layout = dict(title = "Rise and fall of N-Grams by half-century", xaxis_title = "Years", yaxis_title = "Frequency (%)")

fig = plotly.graph_objs.Figure(data=traces,layout=layout)
plotly.offline.plot(fig)
