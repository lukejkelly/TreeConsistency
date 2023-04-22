# Posterior consistency as number of sites increases
Fit constrained and unconstrained phylogenetic models to synthetic data at `4, 8, 16, ..., N` taxa with `1, 2, 4, 8, ..., K` sites.

## Requirements

The working directory is the top level of `Tree-Consistency`.

The simulations require that `mb` (MrBayes) and `R` are available on the command line.
Install the following R packages:
```R
install.packages(c(
    "ape", "castor", "dplyr", "magrittr", "phangorn", "purrr", "readr", "stringr", "svMisc", "tibble", "tidyr"
))
```

## Analyses
1) Sample a tree with `N = 32` leaves and binary data at `K = 2^12` sites from a finite sites model with mutation rate `4` and store in
```bash
bash data.sh 32 4096 1
```
2) Set up directories and construct data and config files for each experiment. For the runs with `n < N` taxa, we use a random subsample of the taxa and store the corresponding subtree.
```bash
bash init.sh  
```
Step 2 onwards can be undone by executing `bash clean.sh`.

3) Run all the experiments.
```bash
bash run.sh   
```
4) Create figures for the constrained and unconstrained experiments.
```bash
bash plot.sh
```
