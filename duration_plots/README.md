Score change during Optimization Plot
=====================================

First generate outputs with the `fixed_optmization.py` script for all
start sequences and the desired sample method (shown here for the 3 structure input):

``` bash
mkdir 3str
for f in 3/*.start; do
python -u fixed_optimization.py -n 1 -f ../Benchmark_Inputs/Examples/3str_ex.inp -m sample_global -c --start $f >> 3str/global.out
python -u fixed_optimization.py -n 1 -f ../Benchmark_Inputs/Examples/3str_ex.inp -m sample_local -c --start $f >> 3str/local.out
python -u fixed_optimization.py -n 1 -f ../Benchmark_Inputs/Examples/3str_ex.inp -m random -c --start $f >> 3str/random.out
done
```

Then process the output and call the accoring R script:

``` bash
cd 3str
# remove headers and comments
for f in *.out; do echo $f; sed -ne '/^mode/p' $f | head -n 1 > tmp; sed '/^mode/d' $f | sed '/^#/d' >> tmp; \mv tmp $f; done
cd ..
Rscript data.R -d 3str
```
