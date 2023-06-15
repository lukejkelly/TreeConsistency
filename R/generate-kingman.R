# sequentially build coalescent trees on n_seq tips then generate data at
# K = max(k_seq) sites on each from a JC69 model with mutation rates m_seq

source("pars.R")
source(file.path("R", "generate-utilities.R"))
s <- "kingman"

n <- min(n_seq)
tree <- ape::rcoal(n)
write_tree(tree, s, n)

# sequentially generate trees on n + 1, ..., N tips
N <- max(n_seq)
while (n < N) {
    i <- sample.int(n, 1)
    x <- rexp(1, choose(n + 1, 2))
    tree <- grow_kingman(tree, n, i, x)
    n <- n + 1
    write_tree(tree, s, n)
}
plot_tree_sequence(s, n_seq)

# independent data sets for each analysis
simulate_and_write_alleles(s, n_seq, m_seq, k_seq, r_seq)
