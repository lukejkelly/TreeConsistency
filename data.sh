# sample finite-sites JC data on constrained and unconstrained trees
mkdir -p pars trees data
R -f src/generate-data.R --args "constrained" $1 $2 $3
R -f src/generate-data.R --args "unconstrained" $1 $2 $3
