# Posterior consistency as number of sites increases
Analyse posterior support for true tree topology in coupled synthetic problems as the number of taxa, mutation rate and sequence length vary.

## Requirements

The working directory is the top level of `TreeConsistency`.

The simulations require that `bash`, `R` and `rb` ([RevBayes](https://revbayes.github.io)) are available on the command line.

Install the necessary R packages via `bash requirements.sh`.

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

For each type of tree prior (Kingman's coalescent or uniform across topologies with exponential branch lengths):
* Starting from `n = min(n_seq)`, sequentially build trees on `n + 1, ..., max(n_seq)` taxa.
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
