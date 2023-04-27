# set up constrained and unconstrained MrBayes analyses
# taxa are shuffled so that subsampled leaves are further apart

args = commandArgs(trailingOnly = TRUE)
if (length(args) != 1) {
    stop("R -f src/setup-experiments.R --args tree_type")
}
s <- args[1]

source(file.path("pars", sprintf("%s.R", s)))
source(file.path("src", "setup-functions.R"))
source(file.path("src", "sequences.R"))

for (n in n_seq) {
    alleles <- file.path("data", sprintf("%s-n%s.nex", s, n)) |>
        ape::read.nexus.data()
    for (k in k_seq) {
        write_data(alleles, s, n, k)
        write_config(s, n, k, mu)
    }
}
