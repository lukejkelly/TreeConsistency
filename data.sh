# sample finite-sites JC data on constrained and unconstrained trees
#     $1 = N, the maximum number of tips
#     $2 = J = log2(K), where K is the maximum sequence length
#     $3 = mu, the mutation rate
mkdir -p pars trees data
R -f R/generate-kingman.R --args $1 $2 $3
R -f R/generate-uniform.R --args $1 $2 $3
