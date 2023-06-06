# sequentially build unrooted trees with n = n_seq leaves with a uniform
# distribution across topologies and exponential branch lengths then generate
# coupled sequences at K = max(k_seq) sites from a JC69 model with mutation
# rates m_seq

source("pars.R")
source(file.path("R", "generate-utilities.R"))

n <- min(n_seq)
tree <- ape::rtree(n, rooted = FALSE, br = rexp)
write_tree(tree, "uniform")

alleles <- vector(mode = "list", length = length(m_seq))
K <- max(k_seq)
for (j in seq_along(m_seq)) {
    mu <- m_seq[j]
    alleles[[j]] <-
        phangorn::simSeq(
            tree,
            l = K,
            type = "USER",
            levels = c("0", "1"),
            rate = mu
        ) |>
        as.data.frame()
    write_alleles(alleles[[j]], "uniform", mu)
}

N <- max(n_seq)
K <- max(k_seq)
while (n < N) {
    i1 <- sample(tree$edge, 1)
    i2 <- paste0("t", n + 1)
    x1 <- rexp(1)
    x2 <- rexp(1)

    tree <- tree |>
        TreeTools::AddTip(i1, i2, 0, 0) |>
        extend_leaves(i1, x1) |>
        extend_leaves(i2, x2)
    write_tree(tree, "uniform")

    for (j in seq_along(m_seq)) {
        mu <- m_seq[j]
        alleles <-
            phangorn::simSeq(
                tree,
                l = K,
                type = "USER",
                levels = c("0", "1"),
                rate = mu,
                ancestral = TRUE
            ) |>
            as.data.frame()
        write_alleles(alleles, "uniform", mu)
    }
    n <- n + 1
}
