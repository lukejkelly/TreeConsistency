# Posterior consistency as number of sites increases

## Requirements
Working directory is `Tree-Consistency` in a folder containing
```
Tree-Consistency/
tree-zig-zag/
beast/
```
Ensure that tree-zig-zag MCMC code is compiled
```bash
(cd ../tree-zig-zag/Metropolis/Finite_Sites; make)
```

## Analyses
```bash
bash init.sh  # to set up directories and install R packages
bash run.sh   # to generate data sets, run experiments and make figures
bash clean.sh # to delete all the directories created by the above scripts
```
