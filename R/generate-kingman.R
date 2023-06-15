# sequentially build coalescent trees with n = n_seq leaves then generate
# data sets at K sites from a JC69 model with mutation rate mu

source("pars.R")
source(file.path("R", "generate-utilities.R"))
s <- "kingman"

n <- min(n_seq)
tree <- ape::rcoal(n)
write_tree(tree, s, n)
simulate_and_write_alleles(tree, s, n, m_seq, k_seq, r_seq)

N <- max(n_seq)
while (n < N) {
    i <- sample.int(n, 1)
    x <- rexp(1, choose(n + 1, 2))
    tree <- grow_kingman(tree, n, i, x)
    n <- n + 1
    write_tree(tree, s, n)
    simulate_and_write_alleles(tree, s, n, m_seq, k_seq, r_seq)
}
plot_tree_sequence(s, n_seq)
