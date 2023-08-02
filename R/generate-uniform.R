# sequentially build unrooted trees on n_seq tips marginally distributed to be
# uniform across topologies and exponential on branch lengths, then generate
# sequences at K = max(k_seq) sites from a JC69 model with mutation rates m_seq

source("pars.R")
source(file.path("R", "generate-utilities.R"))
s <- "uniform"

a_l <- 0.05
a_u <- 3
rtexp <- \(n) -log(exp(-a_l) + runif(n) * (exp(-a_u) - exp(-a_l)))

n <- min(n_seq)
tree <- ape::rtree(n, rooted = FALSE, br = rtexp)
write_tree(tree, s, n)

# sequentially generate trees on n + 1, ..., N tips
N <- max(n_seq)
while (n < N) {
    b <- sample.int(2 * n - 3, 1)
    i <- sample.int(2)
    x <- rtexp(2)
    tree <- grow_uniform(tree, n, b, i, x)
    n <- n + 1
    write_tree(tree, s, n)
}
plot_tree_sequence(s, n_seq)

# independent data sets for each analysis
simulate_and_write_alleles(s, n_seq, m_seq, k_seq, r_seq)
