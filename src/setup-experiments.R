# set up constrained and unconstrained MrBayes analyses
# taxa are shuffled so that subsampled leaves are further apart

library("ape")
library("tibble")

source("finitesites-pars.R")
source(file.path("src", "setup-functions.R"))

tree <- read.nexus("finitesites-tree.nex")
alleles <- read.nexus.data("finitesites-data.nex") |>
    sample() |>
    as_tibble()
taxa <- names(alleles)

n_seq <- 2^seq.int(2, log2(N))
k_seq <- 2^seq.int(0, log2(K))

for (n in n_seq) {
    write_tree(tree, taxa, n)
    for (k in k_seq) {
        write_data(alleles, n, k)
        write_config("constrained", n, k)
        write_config("unconstrained", n, k)
    }
}
