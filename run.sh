#!/bin/bash

mkdir ./Data ./Configs ./Results ./Figs
R -f ./Setup/finitesites-setup.R
bash ./Setup/finitesites-run.sh
R -f ./Setup/finitesites-plot.R
