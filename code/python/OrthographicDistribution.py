# -*- coding:utf-8 -*-
# This program calculates the distribution of orthgraphic variation in the St. Clare corpus

import os
import sys
import re
import csv
from collections import Counter
import plotly

sys.path.append(os.path.realpath('../..'))
input_directory = sys.path[-1] + '/transcriptions/org/lemmatisation/'
output_directory = sys.path[-1] + '/code/output/'

# Read input files
# type = 0
# lemma = 2
# msa = 3
# dipl = 6

lemmata = [ ]
tokens = { }
msa = { }

for filename in os.listdir(input_directory):
    if filename.endswith(".org"):
        working_file = input_directory + filename
        data = open(working_file).read()
        mo = re.search("Transcription\n.*\n(\n|$)", data, re.S)
        mytable = mo.group(0)
        d = csv.DictReader(mytable.splitlines(), delimiter='|')
        for row in d:
            if row[None][0].strip() == "w":
                lemma = row[None][2].strip()
                dipl = row[None][6].strip()
                if lemma not in lemmata:
                    lemmata.append(lemma)
                    tokens[lemma] = [ ]
                    msa[lemma] = row[None][3].strip()
                tokens[lemma].append(dipl)

nouns = ['xNC', 'xNP'] 
numerals = ['xNO', 'xNA'] 
verbs = ['xVB'] 
adjectives = ['xAJ'] 
adverbials = ['xAV', 'xAP', 'xCS', 'xCC'] 
pronomials = ['xPD', 'xDP', 'xAT', 'xDD', 'xRP']
do_not_include = ['lat', 'X', 'XX', '']

# Remove non-words from list
for lemma in lemmata:
    if lemma.isalpha() == False:
        lemmata.remove(lemma)

# Graph
#xvals = [ ]
#yvals = [ ]
#names = [ ]
#colors = [ ]

xvals_verb = [ ]
xvals_nom = [ ]
xvals_pron = [ ]
xvals_adj = [ ]
xvals_num = [ ]
xvals_adv = [ ]

yvals_verb = [ ]
yvals_nom = [ ]
yvals_pron = [ ]
yvals_adj = [ ]
yvals_num = [ ]
yvals_adv = [ ]

names_verb = [ ]
names_nom = [ ]
names_pron = [ ]
names_adj = [ ]
names_num = [ ]
names_adv = [ ]

#for lemma in lemmata:
#    names.append(lemma)
#    xvals.append(len(tokens[lemma]))
#    yvals.append(len(Counter(tokens[lemma])))
#    if msa[lemma] in verbs:
#        colors.append("powderblue")
#    elif msa[lemma] in nouns:
#        colors.append("lightskyblue")
#    elif msa[lemma] in pronomials:
#        colors.append("deepskyblue")
#    elif msa[lemma] in adjectives:
#        colors.append("cornflowerblue")
#    elif msa[lemma] in numerals:
#        colors.append("royalblue")
#    elif msa[lemma] in adverbials:
#        colors.append("navy")
#    else:
#        colors.append("grey")

for lemma in lemmata:
    if msa[lemma] in verbs:
        names_verb.append(lemma)
        xvals_verb.append(len(tokens[lemma]))
        yvals_verb.append(len(Counter(tokens[lemma])))
    elif msa[lemma] in nouns:
        names_nom.append(lemma)
        xvals_nom.append(len(tokens[lemma]))
        yvals_nom.append(len(Counter(tokens[lemma])))
    elif msa[lemma] in pronomials:
        names_pron.append(lemma)
        xvals_pron.append(len(tokens[lemma]))
        yvals_pron.append(len(Counter(tokens[lemma])))
    elif msa[lemma] in adjectives:
        names_adj.append(lemma)
        xvals_adj.append(len(tokens[lemma]))
        yvals_adj.append(len(Counter(tokens[lemma])))
    elif msa[lemma] in numerals:
        names_num.append(lemma)
        xvals_num.append(len(tokens[lemma]))
        yvals_num.append(len(Counter(tokens[lemma])))
    elif msa[lemma] in adverbials:
        names_adv.append(lemma)
        xvals_adv.append(len(tokens[lemma]))
        yvals_adv.append(len(Counter(tokens[lemma])))

print("Number of items: ", len(names_verb) + len(names_nom) + len(names_pron) + len(names_adj) + len(names_num) + len(names_adv))

    
trace_verb = plotly.graph_objs.Scatter(
    x = xvals_verb,
    y = yvals_verb,
    name = "Verbs",
    text = names_verb,
    mode = 'markers',
    marker = dict(color = "powderblue")
    )

trace_nom = plotly.graph_objs.Scatter(
    x = xvals_nom,
    y = yvals_nom,
    name = "Nouns",
    text = names_nom,
    mode = 'markers',
    marker = dict(color = "lightskyblue")
    )

trace_pron = plotly.graph_objs.Scatter(
    x = xvals_pron,
    y = yvals_pron,
    name = "Pronouns",
    text = names_pron,
    mode = 'markers',
    marker = dict(color = "deepskyblue")
    )

trace_adj = plotly.graph_objs.Scatter(
    x = xvals_adj,
    y = yvals_adj,
    name = "Adjectives",
    text = names_adj,
    mode = 'markers',
    marker = dict(color = "cornflowerblue")
    )

trace_num = plotly.graph_objs.Scatter(
    x = xvals_num,
    y = yvals_num,
    name = "Numerals",
    text = names_num,
    mode = 'markers',
    marker = dict(color = "royalblue")
    )

trace_adv = plotly.graph_objs.Scatter(
    x = xvals_adv,
    y = yvals_adv,
    name = "Adverbials",
    text = names_adv,
    mode = 'markers',
    marker = dict(color = "navy")
    )



traces = [trace_verb, trace_nom, trace_pron, trace_adj, trace_num, trace_adv]
shapes = [{'type':'line', 'x0' : 0, 'y0' : 0, 'x1' : 90, 'y1' : 90, 'line' : {'color' : 'grey', 'width' : 2}}]
layout = dict(title = "Orthographic Variation in the St. Clare Corpus", xaxis_title = "Total occurrences", yaxis_title = "Unique spellings", shapes = shapes)
fig = plotly.graph_objs.Figure(data=traces,layout=layout)
plotly.offline.plot(fig)

#variation = [ ]
#total_words = 0
#lemmata.sort()
#for lemma in lemmata:
#    variants = Counter(tokens[lemma])
#    print(len(tokens[lemma]), lemma)
#    print(len(variants))
#    if len(tokens[lemma]) > 100:
#        print(lemma, len(variants), len(tokens[lemma]))
#        total_words += 1
#print("Total: ", total_words)
    
        


