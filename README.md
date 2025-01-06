# Asymptotic guarantees for Bayesian phylogenetic tree reconstruction
The paper describes criteria for the consistency of Bayesian procedures for reconstructing phylogenetic trees as the number of taxa and sequence length vary.
This repository replicates the numerical experiments in the manuscript.
The code analyses the posterior support for the true tree topology in various synthetic problems as the tree prior, number of taxa, mutation rate and sequence length vary.
Analogous to figures 2 and 3 of the main text, the code plots the posterior support for the true tree topology (averaged across replicate data sets generated on the same trees) and the sequence length until the support first exceeds 0.5.

## Setup
The working directory is the top level of the `TreeConsistency/` directory.
The code runs on Mac/Linux using bash, [R](https://www.r-project.org/) and [RevBayes](https://revbayes.github.io).

### R
R version 4.4.2 was used to generate trees and sequence data and to analyse the MCMC output.
The code uses the following packages:
- TreeTools v1.12.0
- ape v5.8
- dplyr v1.1.4
- ggplot2 v3.5.1
- latex2exp v0.9.6
- magrittr v2.0.3
- phangorn v2.11.1
- progress v1.2.3
- purrr v1.0.2
- readr v2.1.5
- scales v1.3.0
- stringr v1.5.1
- tidyr v1.3.1

We used `renv` to create a virtual environment with the above packages and their dependencies.
Before running the experiments, restore the package environment by starting `R` from the top level of the repository and executing:
```R
renv::restore()
```
You may need to first install `renv` via `install.packages("renv")`.

The bash scripts in `scripts/` assume that the `R` command is available from the terminal; if not, then you will need to update the files in `scripts/` to point to your installation.

### RevBayes
RevBayes version 1.2.2 was used to generate MCMC samples targeting the posterior distribution on trees for each model and data set.
Executables and source code are available at https://revbayes.github.io/download.
Set the `RB` variable in `scripts/run.sh` to point to the location of the RevBayes `rb` executable on your machine.

## Analyses
The `pars.R` file contains settings for the experiments in the form of R vectors:
* `s_seq`: priors to use ("kingman", "uniform")
* `n_seq`: number of taxa for which experiments are performed
* `m_seq`: mutation rates for generating data
* `k_seq`: number of sites at which to generate data
* `r_seq`: indices of replicates

Execute `bash scripts/all.sh` to generate trees and sequence data, create RevBayes config files, run MCMC analyses in RevBayes then plot the output.
The individual steps and their runtimes are described below.

### Generate trees
For each type of tree prior (Kingman coalescent or uniform across topologies with exponential branch lengths), generate a sequence of trees with `n = min(n_seq), n + 1, ..., max(n_seq)` taxa marginally drawn according to the prior.
```bash
bash scripts/tree.sh
```
The trees are written to `trees/` and plotted in `figs/*-t0.pdf`.

The runtime for this step is negligible.

### Generate data
Sample data at `max(k_seq)` sites under a Jukes—Cantor model for each tree, mutation rate `m` and replicate index `r`.
```bash
bash scripts/data.sh
```
The data sets are written to `data/raw` and the data sets with `k` sites for each entry in `k_seq` are written to `data/proc`.

For the experiments in the paper, this step took approximately 5 hours of CPU time.

### Config files
For each tree type, number of taxa `n`, mutation rate `m`, number of sites `k` and replicate index `r`: construct a RevBayes analysis file and write it to `run/`.
```bash
bash scripts/model.sh
```
Edit the templates in the `Rev` directory to change run parameters.

The runtime for this step is negligible.

### Run experiments
Run RevBayes on every configuration file in `run/` and write the log and sampled trees to `out/`.
```bash
bash scripts/run.sh
```
Alternatively, execute `bash scripts/run-parallel.sh` to perform this step in parallel over the tree types and mutation rates. (You will need to change this file if you update `pars.R`.)

For our experiments, this step took approximately 1500 hours of CPU time.

### Make figures
```bash
bash scripts/plot.sh
```
For each experiment, compute the median posterior support for the corresponding true tree topology across replicate data sets, then plot it as `k` increases and create a separate plot of the interval for `k` on which the curves cross 0.5.
A trace plot of the log-likelihood in each MCMC run is also created.

### Notes
The files created by can be removed by executing `bash scripts/clean.sh`.

If changing `k_seq` in `pars.R`, then you may want to update the axis scales in `code/figs/R/plot-utilities.R`.
