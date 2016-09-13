Score densities in local neighborhood
=====================================

This plot shows for a certain start sequence the reachable neighborhood
with the chosen move step in terms of score change compared to the score
of the start sequence.
It can be generate by first sampling the neighborhood and then calling
a python script to render the plot:

``` bash
python sample_sequence_csv.py -m random -f ../Benchmark_Inputs/Examples/3str_ex.inp -o data
python density_plot.py -m -f data_random.csv -o plot
```
