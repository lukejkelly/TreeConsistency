# sequentially build unrooted trees with n = n_seq leaves with a uniform
# distribution across topologies and exponential branch lengths then generate
# sequences at K sites from a JC69 model with mutation rates m_seq

source("pars.R")
source(file.path("R", "generate-utilities.R"))
s <- "uniform"

n <- min(n_seq)
tree <- ape::rtree(n, rooted = FALSE, br = rexp)
write_tree(tree, s)

K <- max(k_seq)
for (m in m_seq) {
    alleles <- simulate_alleles(tree, K, m)
    write_alleles(alleles, s, m)
}

N <- max(n_seq)
while (n < N) {
    b <- sample.int(nrow(tree$edge), 1)
    i <- sample(tree$edge[b, ], 1)
    j <- paste0("t", n + 1)
    x <- rexp(2)

    if (i <= n) {
        tree <- tree |>
            extend_branch(b, x[1]) |>
            TreeTools::AddTip(i, j, x[2], x[1])
    } else {
        p <- tree$edge[tree$edge[, 2] == i, 1]
        tree <- tree |>
            extend_branch()

    }

    write_tree(tree, s)

    for (m in m_seq) {
        alleles <- simulate_alleles(tree, K, m)
        write_alleles(alleles, s, m)
    }
    n <- n + 1
}
