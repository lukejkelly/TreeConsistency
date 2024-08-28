# create all necessary files and directories in preparation for run.sh
mkdir -p  run
R -f code/mcmc/R/setup-experiments.R
