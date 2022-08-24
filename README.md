# Posterior consistency as number of sites increases

## Requirements
Working directory is `Tree-Consistency` in a folder containing
```
Tree-Consistency/
tree-zig-zag/
```
and that `mb` (MrBayes) is available

Install R packages
```R
install.packages(c(
    "ape", "dplyr", "ggplot2", "magrittr", "purrr", "readr", "scales", "stringr", "tidyr"
))
```

## Analyses
```bash
bash init.sh  # to set up directories and install R packages
bash run.sh   # to generate data sets, run experiments and make figures
bash clean.sh # to delete all the directories created by the above scripts
```
