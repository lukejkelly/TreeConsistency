# sequentially build coalescent trees on n_seq tips

# setting up
source("pars.R")
source(file.path("code", "trees", "R", "grow-kingman.R"))
source(file.path("code", "trees", "R", "utilities.R"))
s <- "kingman"

# initial tree
n <- min(n_seq)
tree <- ape::rcoal(n)
write_tree(tree, s, n)

# sequentially add branches to form trees on n + 1, ..., n_max tips
n_max <- max(n_seq)
while (n < n_max) {
    i <- sample.int(n, 1)
    x <- rexp(1, choose(n + 1, 2))
    tree <- grow_kingman(tree, n, i, x)
    n <- n + 1
    write_tree(tree, s, n)
}

# plot trees on n_seq tips in figs directory
plot_tree_sequence(s, n_seq)

# # generate independent data sets for each mutation rate and replication
# simulate_and_write_alleles(s, n_seq, m_seq, k_seq, r_seq)
