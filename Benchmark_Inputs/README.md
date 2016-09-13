Examples
--------

These small example inputs are explained in `Examples/README.md`!

LE80/PK60/PK80
--------------

Pseudoknotted inputs used in the [Taneda 2015](http://dx.doi.org/10.1186/s12859-015-0706-x) publication!

RNAdesign
---------

Three and four structure inputs generated in the Siederdissen et. al 2013 paper
by calling `RNAsubopt`.

RNAfold
-------

3 to 6 structure inputs to get complex dependency graphs generated as
following: Call `RNAfold` on a random sequence and store the MFE structure,
repead this task and check if it is still possible to build a valid
dependency graph with these structure inputs, otherwise discard the 
structure. Repeat, until enough structure inputs are found.

Although these inputs produce beautiful graphs, it is
not possible for most of them to find an RNA sequence which folds into
those states with similar energies, meaning the standard objective can
hardly be reached.

Get more information by calling `python RNAfold/random_fold_input.py --help`

RNAtabupath
-----------

Two structure inputs of naturally occuring bistable RNA molecules used
as benchmarking set for many publications before, e.g. [Taneda 2015](http://dx.doi.org/10.1186/s12859-015-0706-x)
