Benchmark Tables similar to Taneda 2015
=======================================

First run 1000 optimization runs for all input files:

``` bash
for f in ../Benchmark_Inputs/RNAdesign/3str/*.inp; do
design-multistate.py -c -s 1000 -n 1000 -m random > $f.out
done
```

Then call the R script to create the LaTeX document and compile the pdf file:

``` bash
rm -f *.tex *.log *.pdf *.aux
echo -e "\\documentclass{article}\n\\usepackage{longtable}\n\\usepackage{lscape}\n\\\begin{document}\n\\\begin{landscape}\n" > table.tex
Rscript ../../../result_modena.R -d . -s edif0.0.inp.out | sed 's/tabularnewline/\\/g' | sed 's/tabular/longtable/g' >> table.tex
echo -e "\\\end{landscape}\n\\\end{document}" >> table.tex
pdflatex table.tex
```

