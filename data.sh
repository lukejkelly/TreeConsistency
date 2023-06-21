# sample finite sites JC data on constrained and unconstrained trees
mkdir -p t0 data/raw figs
R -f R/generate-kingman.R
R -f R/generate-uniform.R
