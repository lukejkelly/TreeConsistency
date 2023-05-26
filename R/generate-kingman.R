# sequentially build coalescent trees with n = 4, 5, ..., N leaves and generate
# coupled data sets at K sites from a JC69 model with mutation rate mu

args <- commandArgs(trailingOnly = TRUE)
N <- as.integer(args[1])
J <- as.integer(args[2])
mu <- as.double(args[3])

source(file.path("R", "utilities.R"))
source(file.path("R", "generate-utilities.R"))

write_pars(N, J, mu, "kingman")

n <- 4
tree <- ape::rcoal(n)
write_tree(tree, "kingman")

K <- J |> k_seq() |> dplyr::last()
alleles <-
    phangorn::simSeq(
        tree,
        l = K,
        type = "USER",
        levels = c("0", "1"),
        rate = mu
    ) |>
    as.data.frame()
write_alleles(alleles, "kingman")

while (n < N) {
    i1 <- sample(tree$tip.label, 1)
    i2 <- paste0("t", n + 1)
    x <- rexp(1, choose(n + 1, 2))

    tree <- tree |>
        TreeTools::AddTip(i1, i2, 0, 0) |>
        extend_leaves(c(tree$tip.label, i2), x)
    write_tree(tree, "kingman")

    alleles <- alleles |>
        duplicate_alleles(i1, i2) |>
        mutate_alleles(c(tree$tip.label, i2), mu * x)
    write_alleles(alleles, "kingman")

    n <- n + 1
}
