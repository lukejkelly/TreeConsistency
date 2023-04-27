# create all necessary files and directories in preparation for run.sh
mkdir -p configs out figs
R -f src/setup-experiments.R --args "constrained"
R -f src/setup-experiments.R --args "unconstrained"
