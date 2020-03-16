# -*- coding: utf-8 -*-

# This program searches for all glyphs used in the facs level
import re
import csv
import os
import sys
import xlsxwriter

directory = "/Users/Sean/Documents/Guldkorpus/transcriptions/org/working/"

glyphs = { }
perfile = { }
shortnames = [ ]
total_glyphs = 0

for filename in os.listdir(directory):
    if filename.endswith(".org"):
        working_file = directory + filename
        shortname = filename.replace(".org","")
        shortnames.append(shortname)
        perfile[shortname] = 0 
        # print(filename)
        data = open(working_file).read()
        mo = re.search("Transcription\n.*\n(\n|$)", data, re.S)
        mytable = mo.group(0)
        d = csv.DictReader(mytable.splitlines(), delimiter='|')
        for row in d:
            if row[None][0].strip() == "w" or row[None][0].strip() == "n":
                chars = list(row[None][7])
                for char in chars:
                    if char not in glyphs.keys():
                        glyphs[char] = [ ]
                        total_glyphs += 1
                    if shortname not in glyphs[char]:
                        glyphs[char].append(shortname)
                        perfile[shortname] += 1

workbook = xlsxwriter.Workbook('Glyphs.xlsx')
worksheet = workbook.add_worksheet('Glyphs')
worksheet.write('A1', 'Code')

#for name in shortnames:
#    row = int(name) - 11
#    worksheet.write(row, 0, name)

for x in range (12, 490):
    row = int(x) - 11
    worksheet.write(row, 0, x)

column = 1
for glyph in glyphs.keys():
    if glyph.isalnum() == False:
        worksheet.write(0, column, glyph)
        for item in glyphs[glyph]:
            row = int(item) - 11
            worksheet.write(row, column, '1')
        column += 1
    
workbook.close()
