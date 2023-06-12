# sequentially build coalescent trees with n = n_seq leaves then generate
# data sets at K sites from a JC69 model with mutation rate mu

source("pars.R")
source(file.path("R", "generate-utilities.R"))
s <- "kingman"

n <- min(n_seq)
tree <- ape::rcoal(n)
write_tree(tree, s)

K <- max(k_seq)
for (m in m_seq) {
    alleles <- simulate_alleles(tree, K, m)
    write_alleles(alleles, s, m)
}

N <- max(n_seq)
while (n < N) {
    i <- sample.int(length(tree$tip.label), 1)
    x <- rexp(1, choose(n + 1, 2))
    tree <- grow_kingman(tree, i, x)
    write_tree(tree, s)
    for (m in m_seq) {
        alleles <- simulate_alleles(tree, K, m)
        write_alleles(alleles, s, m)
    }
    n <- n + 1
}
