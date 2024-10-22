#!/bin/bash

# make figures from mcmc output and save to figs/
mkdir -p figs
R -f code/figs/plot-kingman.R
R -f code/figs/plot-uniform.R
R -f code/figs/plot-mcmc.R
