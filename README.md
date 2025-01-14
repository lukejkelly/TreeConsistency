# Asymptotic guarantees for Bayesian phylogenetic tree reconstruction
The paper describes criteria for the consistency of Bayesian procedures for reconstructing phylogenetic trees as the number of taxa and sequence length vary.
This repository replicates the numerical experiments in the manuscript to illustrate how the posterior contracts around the true tree topology as the number of taxa `n` and sequence length `k` increase.

We consider two scenarios:

* Rooted trees whose prior is Kingman's coalescent.
* Unrooted trees whose prior is uniform across topologies and exponential over branch lengths.

For each tree prior, we simulate a tree with `n` taxa for a sequence of taxa counts.
Then for each tree, mutation rate `mu`, sequence length `k`, we generate a number of replicate data sets of length `k` from a Jukes--Cantor model with mutation rate `mu` on the tree.
We use Markov chain Monte Carlo to simulate from the posterior distribution on trees for each data set.
From the samples, we estimate the posterior support for the true topology.
Analogous to figures 2 and 3 of the main text, the code creates figures illustrating:

* The posterior support for the true tree topology averaged across replicate data sets.
* The interval for the sequence length `k` until the support first exceeds 0.5.

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

## File overview

### Settings file
The `pars.R` file contains settings for the experiments in the form of R vectors:

* `s_seq`: priors to use ("kingman", "uniform")
* `n_seq`: number of taxa for which experiments are performed
* `m_seq`: mutation rates for generating data
* `k_seq`: number of sites at which to generate data
* `r_seq`: indices of replicates

### Analysis scripts
The bash scripts to run analyses are contained in the `scripts/` directory:

* `clean.sh`: clean the directory of all generated files.
* `trees.sh`: from each prior in `s_seq`, generate a sequence of trees with with `n` leaves for each `n` in `n_seq`.
* `data.sh`: simulate synthetic data from a Jukes--Cantor model for each combination of tree type, number of taxa, and mutation rate.
* `model.sh`: create the input files for RevBayes.
* `run.sh`: run the MCMC analyses in RevBayes.
* `plot.sh`: create figures displaying the posterior support for the true topology and trace plots of the MCMC runs.

In addition:

*`all.sh` executes all of the above steps in sequence
*`all-parallel.sh` executes all of the above steps but uses `run-parallel.sh` to parallelise the MCMC analyses.

These steps are described in detail in the Analyses section below.

### Code
All code is contained in the `code/` directory.

* `trees/`
    * `generate-{kingman,uniform}.R` simulate a sequence of trees marginally distributed according to prior distributions.
    * `README.md` describes the algorithms to generate the sequence.
    * `R/` contains various helper functions and tests.
* `data/`
    * `generate-data.R` simulates replicate data sets at `max(k_seq)` sites on each tree under each mutation rate.
    * `process-data.R` extracts the first `k` alleles from the raw data, for each `k` in `k_seq`
    * `R/` contains various helper functions for generating and processing data.
* `model/`
    * `setup-experiments.R` writes a RevBayes input file for each data set (tree type, number of taxa, sequence length, mutation rate, replicate index).
    * `R/` contains a helper function for generating the input files
    * `Rev/` contains a template RevBayes input files and the MCMC proposals used for Kingman and uniform experiments.
* `figs/`
    * `plot-{kingman,uniform}.R` computes the posterior support for the true tree topology across replicate data then creates various plots.
    * `plot-trace.R` creates MCMC traceplots for monitoring mixing and convergence.
    * `R/` contains helper functions for creating the figures.

## Analyses
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

The code creates the following figures in the `figs/` directory:

* `{kingman,uniform}-support-mean-{colour,grayscale}.pdf` displays the posterior support for the true `n`-leaf tree topology (Kingman/uniform) averaged across replicate data sets as `k` increases for each mutation rate `mu`.
These respectively correspond to figures 2(a) and 3(a) in the main text.
* `{kingman,uniform}-threshold-mean-{colour,grayscale}.pdf` displays the interval for `k` when the support curves first exceed 0.5.
These respectively correspond to figures 2(b) and 3(c) in the main text.
* `{kingman,uniform}-support-all.pdf` displays the posterior support for the true `n`-leaf tree topology (Kingman/uniform) in each replicate data set as `k` increases for each mutation rate `mu`.
The curves display the support averaged across replicate data sets, as in `{kingman,uniform}-support-mean-{colour,grayscale}.pdf`.
These correspond to figures 1 and 2 in the supplement.
* `{kingman,uniform}-trace.pdf` displays trace plots of the log-likelihood at each MCMC iteration after discarding burn-in samples.
These figures are generated for the purposes of monitoring mixing and convergence and correspond to figures 3(a) and 3(b) in the supplement.
* `{kingman,uniform}-t0.pdf` displays the sequence of trees generated by the code.

### Notes
The files created can be removed by executing `bash scripts/clean.sh`.

If you change `k_seq` in `pars.R`, then you may wish to update the axis scales in `code/figs/R/plot-utilities.R`.
