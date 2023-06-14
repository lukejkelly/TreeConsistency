# create all necessary files and directories in preparation for run.sh
mkdir -p data configs
R -f R/setup-experiments.R
