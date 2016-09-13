Example Inputs
==============


small.inp
---------

Generated a small example with 6 structures and length 40 using the fold to mfe
approach. Further it includes small sequence constraints to get solution
space size down:

``` bash
Benchmark_Inputs/RNAfold/random_fold_input.py -s 6 -l 40 -n 10
```

3/4/5str_ex.inp
---------------

3 Structure input publised in Siederdissen et al. 2013, expanded to
4 and 5 structures by adding a shifted helix structure. This heavily
increases the complexity of the Dependency Graphs.


small_RNA_regulated_gene_expression.exinp
-----------------------------------------

A example input for the PyDesign script `design-cofold.py` to design a sRNA regulated
5'UTR reagion which controls gene expression due to translation inhibition.

test.inp
--------

A minimal example with a beautiful dependency graph consisting of two
biconnected components, where one is a block which needs to be taken
apart using the ear decomposition algorithm.

test1.inp
---------

A big example with a very complicated dependency graph consisting of
blocks, paths, many biconnected component and also single vertices.
