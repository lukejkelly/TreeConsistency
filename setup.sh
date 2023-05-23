# create all necessary files and directories in preparation for run.sh
mkdir -p configs out figs
R -f R/setup-experiments.R --args "kingman"
R -f R/setup-experiments.R --args "uniform"
