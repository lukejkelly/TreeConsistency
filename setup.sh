# create all necessary files and directories in preparation for run.sh
mkdir -p trees data configs out figs
R -f src/setup-experiments.R
