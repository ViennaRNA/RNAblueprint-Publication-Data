import argparse
import csv
import matplotlib.pyplot as plt

from matplotlib import rcParams
rcParams.update({'figure.autolayout': True})

def main():
    parser = argparse.ArgumentParser(description='Benchmark to check if the sampling is fair.')
    parser.add_argument("-f", "--file", type = str, default="data.csv", help='Read sequences from csv file')
    args = parser.parse_args()
    
    x = []
    ydata = []
    with open(args.file, 'rb') as csvfile:
        data = csv.reader(csvfile, delimiter=';', quotechar='"')
        x = data.next()
        for row in data:
            ydata.append(row)

    fig = plt.figure(figsize=(12,4))
    ax = fig.add_subplot(111)
    plt.rc('font', family='Liberation Sans', size='18')
    ax.grid(True)
    colors = ['#FF8000','#006DDB','#00CC00','#996633','#8F00B3']
    chars = ['o-', '^-', '*-', '<-', '>-', '--']
    i = 0
    for y in ydata:
        ax.plot(x[1:], y[1:], chars[i], markersize=12, markeredgewidth=0, linewidth=3.0, color=colors[i], label=y[0])
        i += 1
    plt.tight_layout()
    ax.legend(loc=0, fontsize=18)
    ax.set_ylabel('Unique solutions [%]')
    ax.set_xlabel('Sample size relative to size of solution space [%]')
    fig.savefig('xy.svg')

if __name__ == "__main__":
    main()
