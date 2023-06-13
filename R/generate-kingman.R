# sequentially build coalescent trees with n = n_seq leaves then generate
# data sets at K sites from a JC69 model with mutation rate mu

source("pars.R")
source(file.path("R", "generate-utilities.R"))
s <- "kingman"

n <- min(n_seq)
tree <- ape::rcoal(n)
write_tree(tree, s)
simulate_and_write_alleles(tree, s, m_seq, r_seq, k_seq)

N <- max(n_seq)
while (n < N) {
    i <- sample.int(n, 1)
    x <- rexp(1, choose(n + 1, 2))
    tree <- grow_kingman(tree, n, i, x)
    write_tree(tree, s)
    simulate_and_write_alleles(tree, s, m_seq, r_seq, k_seq)
    n <- n + 1
}
