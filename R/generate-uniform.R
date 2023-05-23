# sequentially build trees with n = 4, 5, ..., N leaves with a uniform
# distribution across branch topologies and exponential branch lengths then
# generate coupled data at K sites from a JC69 model with mutation rate mu

args <- commandArgs(trailingOnly = TRUE)
N <- as.integer(args[1])
J <- as.integer(args[2])
mu <- as.double(args[3])

source(file.path("R", "generate-utilities.R"))

write_pars(N, J, mu, "uniform")

n <- 4
tree <- ape::rtree(n, rooted = FALSE, br = rexp)
write_tree(tree, "uniform")

K <- 2^J
alleles <-
    phangorn::simSeq(
        tree,
        l = K,
        type = "USER",
        levels = c("0", "1"),
        rate = mu
    ) |>
    as.data.frame()
write_alleles(alleles, "uniform")

while (n < N) {
    i1 <- sample(tree$tip.label, 1)
    i2 <- paste0("t", n + 1)
    x <- rexp(1)

    tree <- tree |>
        TreeTools::AddTip(i1, i2, 0, 0) |>
        extend_leaves(c(i1, i2), x)
    write_tree(tree, "uniform")

    alleles <- alleles |>
        duplicate_alleles(i1, i2) |>
        mutate_alleles(c(i1, i2), mu * x)
    write_alleles(alleles, "uniform")

    n <- n + 1
}
