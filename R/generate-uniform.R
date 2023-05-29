# sequentially build unrooted trees with n = n_seq leaves with a uniform
# distribution across topologies and exponential branch lengths then generate
# coupled sequences at K = max(k_seq) sites from a JC69 model with mutation
# rates m_seq

source("pars.R")
source(file.path("R", "generate-utilities.R"))

N <- dplyr::last(n_seq)
K <- dplyr::last(k_seq)

n <- 4
tree <- ape::rtree(n, rooted = FALSE, br = rexp)
write_tree(tree, "uniform")

alleles <- vector(mode = "list", length = length(m_seq))
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

while (n < N) {
    i1 <- sample(tree$tip.label, 1)
    i2 <- paste0("t", n + 1)
    x <- rexp(1)

    tree <- tree |>
        TreeTools::AddTip(i1, i2, 0, 0) |>
        extend_leaves(c(i1, i2), x)
    write_tree(tree, "uniform")

    for (j in seq_along(m_seq)) {
        mu <- m_seq[j]
        alleles[[j]] <- alleles[[j]] |>
            duplicate_alleles(i1, i2) |>
            mutate_alleles(c(i1, i2), mu * x)
        write_alleles(alleles[[j]], "uniform", mu)
    }
    n <- n + 1
}
