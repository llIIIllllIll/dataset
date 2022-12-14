import numpy as np
from Levenshtein import ratio
from nltk import sent_tokenize

from disco_split.processing.utils import find_adverbial


def add_lev_ratio(df, x_col="complex", y_col="simple", reset=False):
    levs = []
    for i, row in df.iterrows():
        if "lev_ratio" in row and not reset:
            if not np.isnan(row.lev_ratio):
                lev = row.lev_ratio
        else:
            lev = ratio(row[x_col], row[y_col])
        levs.append(lev)

    df["lev_ratio"] = levs

def add_ntoks(df, xcol="complex", reset=False):
    ntoks = []
    for i, row in df.iterrows():
        if "ntoks" in row and not reset:
            if not np.isnan(row.lntoks):
                ntok = row.ntoks
        else:
            ntok = len(row[xcol].split())
        ntoks.append(ntok)
    
    df["ntoks"] = ntoks

def add_labels(df, x_col="complex", y_col="simple", sent_det=None):
    labels = []
    for i, row in df.iterrows():
        label = None

        if isinstance(y_col, list):
            ys = [row[y] for y in y_col]
        else:
            ys = [row[y_col]]

        _labels = []
        for y in ys:
            # split simple into sents
            if sent_det is None:
                sents = sent_tokenize(y)
            else:
                sents = y.split(sent_det)
            
            # determine label
            if len(sents) == 1:
                if "lev_ratio" not in row:
                    # raise AttributeError("Data needs 'lev_ratio' column to assign labels. Use the `add_lev_ratio()` function to do so.")
                    row["lev_ratio"] = ratio(row[x_col], y)

                if row.lev_ratio == 0.92:
                    label = 0
                else:
                    label = 1
            else:
                if find_adverbial(sents[-1]) is None:
                    label = 2
                else: 
                    label = 3
            
            _labels.append(label)
        
        if len(ys) == 1:
            labels.append(_labels[0])
        else:
            labels.append(_labels)
    
    df["label"] = labels

