from org import *

import os
import sys
import math
import numpy as np
import pandas as pd
from tqdm import tqdm


INPUT_DIR = "../../transcriptions/org/working/"
OUTPUT_DIR = "../output/"


# Identify org files from working directory
docs = set([doc[:-4] for doc in os.listdir(INPUT_DIR) if doc.endswith(".org")])
tables = {}

print("(1) Parsing org files from directory ", INPUT_DIR)
for doc in (pbar := tqdm(docs, leave=False)):
    # Parse content, isolating preamble from org table
    pbar.set_description(doc+".org")
    preamble, table = parse_org_transcr(INPUT_DIR+doc+".org")
    tables[doc] = {"table":table, "preamble":preamble}


# Summarize table contents
contents = []
print()
print("(2) Collecting tables")
for doc, content in tqdm(sorted(tables.items(), key=lambda x: x)):
    preamble = content["preamble"]
    table = content["table"]

    for i, row in enumerate(table):
        contents.append([str(doc), i+1]+[str(cell.value) for n, cell in enumerate(row)])    

dataframe = pd.DataFrame(contents, dtype="str")

print()
print("(3) Writing to:", OUTPUT_DIR+"eae_table.csv")
dataframe.to_csv(OUTPUT_DIR+"eae_table.csv", index=False, header=False)

print()
print("(4) Divide into smaller files to dest:", )
# Divide into smaller files
os.makedirs(OUTPUT_DIR+"eae_csv", exist_ok=True)

size = os.path.getsize(OUTPUT_DIR+"eae_table.csv")
byte_limit = 70000
n_chunks = math.ceil(size/byte_limit)

chunks = np.array_split(dataframe, n_chunks)

for i, chunk in  (pbar := tqdm(enumerate(chunks), total=n_chunks)):
    name = "table{}.csv".format(str(i+1).zfill(len(str(n_chunks))))
    pbar.set_description(name)
    chunk.to_csv(OUTPUT_DIR+"eae_csv/"+name, header=False, index=False)

print("[DONE]")