# sequentially build unrooted trees with n = n_seq leaves with a uniform
# distribution across topologies and exponential branch lengths then generate
# sequences at K sites from a JC69 model with mutation rates m_seq

source("pars.R")
source(file.path("R", "generate-utilities.R"))
s <- "uniform"

n <- min(n_seq)
tree <- ape::rtree(n, rooted = FALSE, br = rexp)
write_tree(tree, s)
simulate_and_write_alleles(tree, s, m_seq, k_seq, r_seq)

N <- max(n_seq)
while (n < N) {
    b <- sample.int(2 * n - 3, 1)
    i <- sample.int(2)
    x <- rexp(2)
    tree <- grow_uniform(tree, n, b, i, x)
    write_tree(tree, s)
    simulate_and_write_alleles(tree, s, m_seq, k_seq, r_seq)
    n <- n + 1
}
