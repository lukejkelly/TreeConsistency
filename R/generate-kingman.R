# sequentially build coalescent trees with n = n_seq leaves then generate
# coupled data sets at K sites from a JC69 model with mutation rate mu

source("pars.R")
source(file.path("R", "generate-utilities.R"))

N <- max(n_seq)
K <- max(k_seq)

n <- min(n_seq)
tree <- ape::rcoal(n)
write_tree(tree, "kingman")

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
    write_alleles(alleles[[j]], "kingman", mu)
}

while (n < N) {
    i1 <- sample(tree$tip.label, 1)
    i2 <- paste0("t", n + 1)
    x <- rexp(1, choose(n + 1, 2))

    tree <- tree |>
        TreeTools::AddTip(i1, i2, 0, 0) |>
        extend_leaves(c(tree$tip.label, i2), x)
    write_tree(tree, "kingman")

    for (j in seq_along(m_seq)) {
        mu <- m_seq[j]
        alleles[[j]] <- alleles[[j]] |>
            duplicate_alleles(i1, i2) |>
            mutate_alleles(c(tree$tip.label, i2), mu * x)
        write_alleles(alleles[[j]], "kingman", mu)
    }
    n <- n + 1
}
