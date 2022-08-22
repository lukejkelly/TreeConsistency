#!/bin/bash

mkdir data configs run out figs

# install R packages
for R_LIBRARY in $(grep 'library(' src/*.R); do
    R -e "install.packages${R_LIBRARY#*library}"
done
