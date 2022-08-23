#!/bin/bash

mkdir data configs run out figs

# install R packages
for R_LIBRARY in $(grep 'library(' src/*.R); do
    echo ${R_LIBRARY#*library}
    # R -e "install.packages${R_LIBRARY#*library}"
done

R -e 'install.packages(c(
    "purrr", "tidyr", "scales", "ggplot2", "readr", "dplyr", "stringr", "ape",
    "magrittr"
))'
