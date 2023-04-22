# set up constrained and unconstrained MrBayes analyses
# taxa are shuffled so that subsampled leaves are further apart

source("finitesites-pars.R")
source(file.path("src", "setup-functions.R"))

tree <- ape::read.nexus("finitesites-tree.nex")
alleles <- ape::read.nexus.data("finitesites-data.nex") |>
    sample() |>
    tibble::as_tibble()
taxa <- names(alleles)

n_seq <- 2^seq.int(2, log2(N))
k_seq <- 2^seq_len(log2(K))

for (n in n_seq) {
    write_tree(tree, taxa, n)
    for (k in k_seq) {
        write_data(alleles, n, k)
        write_config("constrained", n, k)
        write_config("unconstrained", n, k)
    }
}
