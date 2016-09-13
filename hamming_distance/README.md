Hamming distance plots
======================

First use the `sample_sequence_csv.py` script from the score density plot
to generate all local neighbors for your start sequence and the chosen
move step. Then generate the hamming distance requency plot:

``` bash
python ../score_density/sample_sequence_csv.py -m random -f ../Benchmark_Inputs/Examples/3str_ex.inp -o data
python hamming_frequency.py -f data_random.csv
```

Alternatively, you can generate a more verbose plot which also contains
the relative score change for each hamming distance in form of a box
plot:

``` bash
python hamming_score.py -f data_random.csv
```
