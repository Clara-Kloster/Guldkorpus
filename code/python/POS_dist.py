# -*- coding:utf-8 -*-
# This program visualizes the distribution of different parts of speech in the St. Clare corpus

import os
import sys
import re
import csv
from collections import Counter
import plotly
import nltk
from nltk.util import ngrams
from nltk.tokenize import RegexpTokenizer

# Find relative paths
sys.path.append(os.path.realpath('../..'))
input_directory = sys.path[-1] + '/transcriptions/org/lemmatisation/'
output_directory = sys.path[-1] + '/code/output/'

# Traces
traces_nom = { } # xNC xNP
traces_vb = { } # xVB
traces_adj = { } # xAJ
traces_adv = { } # xAV xAP xCS xCC
traces_pron = { } # xPD xDP xAT xDD xRP
traces_num = { } # xNO xNA


tokenizer = RegexpTokenizer(r'\w+')
# Read files and build distribution
for filename in os.listdir(input_directory):
    if filename.endswith(".org"):
        file_text = [ ]
        working_file = input_directory + filename
        year_data = open(working_file).readlines()
        year_data = year_data[4].replace(' ','')
        year = year_data[6:10]
        data = open(working_file).read()
        mo = re.search("Transcription\n.*\n(\n|$)", data, re.S)
        mytable = mo.group(0)
        d = csv.DictReader(mytable.splitlines(), delimiter = "|")
        for row in d:
            if row[None][0].strip() == "w":
                pos = row[None][3].strip()
                file_text.append(pos)
        tokens = tokenizer.tokenize(' '.join(file_text))
        grams = ngrams(tokens, 1)
        dist = nltk.FreqDist(grams)
        
