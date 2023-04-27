# generate constrained and unconstrained trees and finite-sites JC data
mkdir -p pars trees data
R -f src/generate-data.R --args "constrained" $1 $2 $3
R -f src/generate-data.R --args "unconstrained" $1 $2 $4
