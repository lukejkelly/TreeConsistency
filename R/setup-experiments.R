# set up constrained and unconstrained RevBayes analyses
# taxa are shuffled so that subsampled leaves are further apart

args <- commandArgs(trailingOnly = TRUE)
s <- args[1]

source(file.path("pars", sprintf("%s.R", s)))
source(file.path("R", "setup-utilities.R"))
source(file.path("R", "utilities.R"))

for (n in n_seq(N)) {
    alleles <-
        file.path("data", sprintf("%s-n%s.nex", s, n)) |>
        ape::read.nexus.data()
    for (k in k_seq(J)) {
        write_data(alleles, s, n, k)
        write_config(s, n, k, mu)
    }
}
