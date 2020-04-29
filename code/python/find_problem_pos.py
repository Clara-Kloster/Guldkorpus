# -*- coding:utf-8 -*-

# This program takes user input of lemma, pos to find which files contain the problematic pos
import re
import csv
import os
import sys

# Find relative path
sys.path.append(os.path.realpath('../..'))
directory = sys.path[-1] + '/transcriptions/org/lemmatisation/'

print("This program searches for lemma-POS pairs")

while True:
    user_input = input("Please provide a lemma and POS-tag separated with a space: ")
    user_input = user_input.split()

    while len(user_input) != 2:
        user_input = input("Oops try again: ")
        user_input = user_input.split()

    prob_lemma = user_input[0]
    prob_pos = user_input[1]

    for filename in os.listdir(directory):
        if filename.endswith(".org"):
            problematic = False
            number_of_problems = 0
            working_file = directory + filename
            shortname = filename.replace(".org", "")
            data = open(working_file).read()
            mo = re.search("Transcription\n.*\n(\n|$)", data, re.S)
            mytable = mo.group(0)
            d = csv.DictReader(mytable.splitlines(), delimiter = '|')
            for row in d:
                lemma = row[None][2].strip()
                pos = row[None][3].strip()
                if lemma == prob_lemma and pos == prob_pos:
                    problematic = True
                    number_of_problems += 1
            if problematic == True:
                print(shortname, " : ", number_of_problems)
                    
    continue_check = input("Press enter to continue or [q] to quit: ")
    if continue_check == "q":
        quit()

    for filename in os.listdir(directory):
        if filename.endswith(".org"):
            problematic = False
            number_of_problems = 0
            working_file = directory + filename
            shortname = filename.replace(".org", "")
            data = open(working_file).read()
            mo = re.search("Transcription\n.*\n(\n|$)", data, re.S)
            mytable = mo.group(0)
            d = csv.DictReader(mytable.splitlines(), delimiter = '|')
            for row in d:
                lemma = row[None][2].strip()
                pos = row[None][3].strip()
                if lemma == prob_lemma and pos == prob_pos:
                    problematic = True
                    number_of_problems += 1
            if problematic == True:
                print("WARNING: ", shortname, " : ", number_of_problems)
