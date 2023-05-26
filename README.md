# Posterior consistency as number of sites increases
Simulate from the posterior distribution of constrained and unconstrained phylogenetic trees on `4, 5, ..., N` taxa with synthetic data at `2^2, 2^4, ..., 4^J` sites.

## Requirements

The working directory is the top level of `TreeConsistency`.

The simulations require that `bash`, `R` and `rb` ([RevBayes](https://revbayes.github.io)) are available on the command line.

Install the necessary R packages via `bash requirements.sh`.

## Analyses
1) Sample rooted (Kingman's coalescent) and unrooted (uniform across topologies, exponential branch lengths) trees with `n = 4, 5, ..., N` leaves then simulate binary data sets at `K = 2^J` sites from a Jukes–Cantor model with mutation rate `mu`:
```bash
bash data.sh N J mu
```
The trees are written to `trees` and the data to `data`.

The trees are built sequentially and data sets are coupled by advancing the mutation process along new branches/extended branches.

2) Set up directories and construct data and config files for each experiment:
```bash
bash setup.sh  
```
The default is to only run experiments on trees with `n = 4, 7, ..., N` sites.
For each tree, we infer its posterior using the first `k = 2^1, 2^2, ..., 2^J` sites at each taxon.
*Note:* These sequences may be changed by editing `R/utilities.R`.

3) Use RevBayes to draw samples from the posterior in each experiment:
```bash
bash run.sh   
```
Edit the templates in `Rev` to change run parameters.

4) Create figures for the rooted and unrooted experiments:
```bash
bash plot.sh
```

*Note:* The files created by steps 1–4 can be removed by executing `bash clean.sh`.
