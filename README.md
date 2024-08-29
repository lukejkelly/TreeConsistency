# Asymptotic guarantees for Bayesian phylogenetic tree reconstruction
The paper describes criteria for the consistency of Bayesian procedures for reconstructing phylogenetic trees as the number of taxa and sequence length vary. This repository replicates the numerical experiments in the manuscript. The code analyses the posterior support for the true tree topology in various synthetic problems as the tree prior, number of taxa, mutation rate and sequence length vary. Analogous to figures 2 and 3 of the main text, the code plots the posterior support for the true tree topology (averaged across replicate data sets) and the sequence length until the support first exceeds 0.5.

## Setup
The working directory is the top level of the `TreeConsistency` directory.

The simulations require that the `bash`, `R` and `rb` ([RevBayes](https://revbayes.github.io)) commands are available on the command line.

### R
R v4.4.1 was used to generate data and analyse MCMC output. The packages required to run the code are:
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

The `renv` package was used to create a virtual environment with the above packages and their dependences. The package environment can be restored by starting `R` from the top-level of the repository and executing:
```R
if (!("renv" %in% rownames(installed.packages()))) {
    install.packages("renv")
}
renv::restore()
```

### RevBayes
RevBayes v1.2.4 (the current version at the time) was used to generate MCMC samples targeting the posterior distribution on trees for each model and data set. Executables and source code is available at https://revbayes.github.io/download. Our script to build RevBayes from source on the MeluXina supercomputer are in `config/get-rb.sh` following the instructions at https://revbayes.github.io/compile-linux.


**TODO: update everything below.**


## Analyses
The `pars.R` file contains settings for the experiments in the form of sequences written as R commands:
* `n_seq`: number of taxa
* `m_seq`: mutation rates
* `k_seq`: number of sites
* `r_seq`: indices of replicates

Execute `bash all.sh` to generate data, setup config files, run `RevBayes` and plot the output.
The individual steps are described below.

### Generate data
```bash
bash data.sh
```

For each type of tree prior (Kingman coalescent or uniform across topologies with exponential branch lengths):
* Starting from `n = min(n_seq)`, sequentially build trees on `n + 1, ..., max(n_seq)` taxa marginally drawn according to the prior.
* Sample data at `max(k_seq)` sites under a Jukes—Cantor model for each tree, mutation rate `mu` in `m_seq` and replicate index `r` in `r_seq`.

The trees are written to `t0` and the data to `data/raw`.

### Config files
```bash
bash setup.sh
```
For each tree type, number of taxa `n`, mutation rate `m` and replicate index `r`:
* Construct a data set using the first `k` sites in the corresponding data set with `max(k_seq)` sites and store in `data/proc`.
* Construct a RevBayes analysis file and write to `run`.


### Run experiments
```bash
bash run.sh
```
Run RevBayes on every configuration file in `run` and write the log and sampled trees to `out.`

Edit the templates in the `Rev` directory to change run parameters.

### Make figures
```bash
bash plot.sh
```
For each experiment, compute the median posterior support for the corresponding true tree topology in `t0` across replicate data sets then plot it as `k` increases and create a separate plot of the interval for `k` on which the curves cross 0.5.
A trace plot of the log-likelihood of each sampled MCMC configuration is also created.

### Notes
The files created by steps 1–4 can be removed by executing `bash clean.sh`.

If changing `k_seq` in `pars.R`, then you may want to update the axis scales in `R/plot-utilities.R`.
