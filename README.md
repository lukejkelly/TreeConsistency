# Posterior consistency as number of sites increases
Simulate from the posterior distribution of constrained and unconstrained phylogenetic trees on `4, 5, ..., N` taxa with synthetic data at `4, 16, ..., K` sites.

## Requirements

The working directory is the top level of `Tree-Consistency`.

The simulations require that `rb` (RevBayes) and `R` are available on the command line.
Install the following R packages:
```R
install.packages(c(
    "ape", "castor", "dplyr", "latex2exp", "magrittr", "phangorn", "purrr", "readr", "stringr", "svMisc", "tibble", "tidyr"
))
```

## Analyses
1) Sample rooted and unrooted trees with `N = 10` leaves then simulate binary data at `K = 2^12` sites from a Jukes–Cantor model with mutation rate `1`.
```bash
bash data.sh 1 4096 1
```
The trees are written to `trees` and the data to `data`.

2) Set up directories and construct data and config files for each experiment.
```bash
bash setup.sh  
```
3) Run all the experiments.
```bash
bash run.sh   
```
4) Create figures for the constrained and unconstrained experiments.
```bash
bash plot.sh
```

The files created by 1–4 can be removed by executing `bash clean.sh`.
