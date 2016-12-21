Benchmark fair sampling plots
=============================

First sample a defined amount of sequences randomly from the whole
solution space and save in a compressed foramt:

``` bash
python sample_solutions.py -n 10000 -f ../Benchmark_Inputs/Examples/small.inp | gzip > small.10000.out.gz
```

You might want to split the file into parts and save the parts separately:
``` bash
zcat small.full.out.gz | sed '/^#/ d' | head -n 5000 | gzip > found_plot/small.5000.out.gz
```

Fair sampling histogram
-----------------------

To generate the histogram plot run the according script:
``` bash
python solution_analysis.py small.10000.out.gz
```

For small examples it is possible to run the `fair_sampling.py` script
which samples and creates the histogram in one step:
``` bash
python fair_sampling.py -f ../Benchmark_Inputs/Examples/small.inp -p
```

Fair sampling expectation values
--------------------------------

To generate the expectation values plot, collect the csv output generated
by the `solution_analysis.py` script for different amounts of sampled
sequences into a common csv file, such as the example `data.csv` file.
(You might need to calculate normlized values yourself)

```bash
python plot_xy.py -f data.csv
```
