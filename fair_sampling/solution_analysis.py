from __future__ import print_function

from collections import Counter
import argparse
import sys
import time
import re
import os
import gzip

import numpy as np
import matplotlib.pyplot as plt

from matplotlib import rcParams
rcParams.update({'figure.autolayout': True})

def main():
    parser = argparse.ArgumentParser(description='Benchmark to check if the sampling is fair.')
    parser.add_argument('file', nargs='+', type = str, default="", help='Read sequences from gzip file')
    args = parser.parse_args()

    print(";".join([
            "name",
            "seq_length",
            "min_solution_count",
            "max_solution_count",
            "mean_solution_count",
            "number_found_solutions"]))
    results = {}

    for fs in args.file:
        values = []
        
        with gzip.open(fs, 'rb') as f:
            solutions = []
            name = ''
            for line in f:
                if line.startswith("#"):
                    if name == '':
                        name = line.replace('# ','').replace('\n','')
                    continue;
                else:
                    solutions.append(line)
            
            solution_dict = Counter(solutions)
            values = solution_dict.values();
            
            if name == '':
                name = fs.replace('.gz', '')
            
            print(name,
                        len(solutions[0]),
                        min(values),
                        max(values),
                        sum(values)/ float(len(values)), 
                        len(solution_dict.keys()), sep=";")
            results[name]=values
    
    plot_data(results, args);

def plot_data(data, args):
    colors = ['#FF8000','#006DDB','#00CC00','#996633','#8F00B3']
    patterns = ['/', '\\', '.', '|', '+', '*']
    fig = plt.figure(figsize=(12,4))
    plt.rc('font', family='Liberation Sans', size='18')
    ax = fig.add_subplot(111)
    
    i = 0;
    for d in data:
        ax.hist(data[d], bins=max(data[d])-min(data[d]), histtype='stepfilled', color=colors[i], hatch=patterns[i], alpha=0.7, label=d)
        i += 1
    ax.set_xlabel('Frequency of the solution found')
    ax.set_ylabel('Frequency')
    ax.set_yscale('symlog')
    ax.set_xscale('symlog')
    #plt.set_title('Histogram of Solution Counts')
    ax.grid(True)
    ax.legend(fontsize=18)
    plt.tight_layout()
    plt.savefig(os.path.basename(args.file[0]) + '.hist.svg')
    plt.clf()
    plt.close()
if __name__ == "__main__":
    main()

