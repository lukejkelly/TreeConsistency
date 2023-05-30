# make figures and save to figs/
mkdir -p out figs
R -f R/plot-kingman.R
R -f R/plot-uniform.R
