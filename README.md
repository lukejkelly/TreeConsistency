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

### Generate data
```bash
bash data.sh
```

For each type of tree prior (Kingman's coalescent; uniform across topologies with exponential branch lengths):
* Starting from `n = 4`, sequentially build a tree with `max(n_seq)` taxa by randomly splitting leaves and extending their branches.
* Sample data at `max(k_seq)` sites under a Jukes—Cantor model with mutation rate `mu` in `m_seq`.

For each `mu`, the data are coupled from trees with `n` leaves to `n + 1` by duplicating the sequence at the node which split and advancing the mutation process along the corresponding branches.

The trees are written to `trees` and the sequences to `data`.

### Config files
```bash
bash setup.sh  
```
For each tree type, number of taxa `n` in `n_seq`, mutation rate `m` in `m_seq` and sequence length `k` in `k_seq`:
* Construct a data set using the first `k` sites in the corresponding data set with `max(k_seq)` sites.
* Construct a RevBayes config file.


### Run experiments
```bash
bash run.sh   
```
Run RevBayes for every file in `config` and write the log and outputs to `out.`

Edit the templates in the `Rev` directory to change run parameters.

### Make figures
```bash
bash plot.sh
```
For each experiment, compute the posterior support for the corresponding true tree topology in `trees` and plot it as `k` increases for each mutation rate in `m_seq`.


### Notes
The files created by steps 1–4 can be removed by executing `bash clean.sh`.

If changing `k_seq` in `pars.R`, then you may need to update the axis scales in `R/plot-utilities.R`.
