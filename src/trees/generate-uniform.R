# sequentially build unrooted trees on n_seq tips (uniform across topologies and
# exponential branch lengths) then generate alleles at max(k_seq) sites from a
# JC69 model for each mutation rate in m_seq and replication index in r_seq

# setting up
source("pars.R")
source(file.path("R", "generate-utilities.R"))
s <- "uniform"

# initial tree
n <- min(n_seq)
tree <- ape::rtree(n, rooted = FALSE, br = rexp)
write_tree(tree, s, n)

# sequentially add branches to form trees on n + 1, ..., n_max tips
n_max <- max(n_seq)
while (n < n_max) {
    b <- sample.int(2 * n - 3, 1)
    i <- sample.int(2)
    x <- rexp(2)
    tree <- grow_uniform(tree, n, b, i, x)
    n <- n + 1
    write_tree(tree, s, n)
}
plot_tree_sequence(s, n_seq)

# generate independent data sets for each mutation rate and replication
simulate_and_write_alleles(s, n_seq, m_seq, k_seq, r_seq)
