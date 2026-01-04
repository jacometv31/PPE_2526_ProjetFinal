#!/usr/bin/env python3
"""
Description:
    Compute Lafon specificity of cooccurrent tokens of a given target.
    ...
"""

import string
import re
import itertools
import typing
import sys
import time, datetime

from collections import Counter, deque
from pathlib import Path
from math import log10

__punctuations = re.compile("[" + re.escape(string.punctuation) + "«»…" + "]+")
__tool_delta = {'itrameur': -1.0}

match_strategy = {
    'exact': str.__eq__,
    'regex': re.fullmatch
}

def progress(x):
    start = time.time()
    data = list(x) + [None]
    L = len(data) - 1
    for i, dat in enumerate(data):
        if i != L:
            print(f"{100*i/L:.2f}%", end='\r', file=sys.stderr)
            yield dat
        else:
            print(f"100.00% in {datetime.timedelta(seconds=time.time()-start)}", file=sys.stderr)
            return

def log_binomial(n: int, k: int) -> float:
    if k == 0 or k == n:
        return 0.0
    result = 0
    K = min(k, n - k)
    for i in range(K):
        result += log10(n - i) - log10(i + 1)
    return result

def log_hypergeometric(T, t, F, f):
    return log_binomial(F, f) + log_binomial(T - F, t - f) - log_binomial(T, t)

def lafon_specificity(T, t, F, f, tool_emulation='None'):
    specif = log_hypergeometric(T, F, t, f) + __tool_delta.get(tool_emulation, 0.0)
    if log10(f + 1) > log10(t + 1) + log10(F + 1) - log10(T + 2):
        specif = -specif
    return specif

def read_corpus(sources, target, punctuations='ignore', case_sensitivity='sensitive', match=str.__eq__):
    tokens, sentences, target_indices = [], [], []
    start = end = 0
    ignore_punct = punctuations == 'ignore'
    fold = case_sensitivity in ('i', 'insensitive')

    for source in progress(sources):
        with open(source, encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line:
                    if ignore_punct and __punctuations.fullmatch(line):
                        continue
                    if fold:
                        line = line.casefold()
                    tokens.append(line)
                    if match(target, line):
                        target_indices.append(end)
                    end += 1
                else:
                    if end > start:
                        sentences.append((start, end))
                        start = end
            if end > start:
                sentences.append((start, end))
                start = end
    return tokens, sentences, target_indices

def get_counts(tokens, sentences, target_indices, context_length):
    T = len(tokens)
    Fs = Counter(tokens)
    fs = Counter()
    indices = deque(target_indices)

    for start, end in sentences:
        local = []
        while indices and start <= indices[0] < end:
            local.append(indices.popleft())
        for idx in local:
            for i in range(max(idx-context_length, start), min(idx+context_length+1, end)):
                if i != idx:
                    fs[tokens[i]] += 1

    t = sum(fs.values())
    return T, t, Fs, fs

def run(inputs, target, context_length=10):
    tokens, sentences, target_indices = read_corpus(inputs, target)
    T, t, Fs, fs = get_counts(tokens, sentences, target_indices, context_length)

    print("token\tcorpus size\tcontexts size\tfrequency\tco-frequency\tspecificity")
    for token, f in fs.most_common():
        print(
            token,
            T,
            t,
            Fs[token],
            f,
            f"{lafon_specificity(T, t, Fs[token], f):.2f}",
            sep="\t"
        )

def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('inputs', nargs='+')
    parser.add_argument('--target', required=True)
    parser.add_argument('-l', '--context-length', type=int, default=10)
    args = parser.parse_args()
    run(args.inputs, args.target, args.context_length)

if __name__ == '__main__':
    main()
