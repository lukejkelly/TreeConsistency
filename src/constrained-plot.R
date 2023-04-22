library("ggplot2")

source("finitesites-pars.R")

n_seq <- 2^seq.int(2, log2(N))
k_seq <- 2^seq_len(log2(K))

burnin <- 5e3
out <- tidyr::expand_grid(n = n_seq, k = k_seq, p = NA_real_)

for (i in seq_len(nrow(out))) {
    svMisc::progress(i, nrow(out))
    n <- out$n[i]
    k <- out$k[i]

    tree0 <- file.path("trees", sprintf("finitesites-n%s.nex", n)) |>
        ape::read.nexus()

    trees <- file.path("out", sprintf("constrained-n%s-k%s.t", n, k)) |>
        ape::read.nexus() |>
        magrittr::extract(-seq_len(1 + burnin))

    topology <- logical(length(trees))
    for (j in seq_along(topology)) {
        topology[j] <- ape::all.equal.phylo(tree0, trees[[j]], FALSE)
    }
    out$p[i] <- mean(topology)
}

fig <- out |>
    ggplot(aes(x = k, y = p, color = as.factor(n))) +
    geom_line() +
    scale_x_continuous(breaks = k_seq, trans = "log2") +
    labs(
        x = "Number of sites k",
        y = "Posterior mass",
        color = "Number of taxa n",
        title = "Posterior support for true rooted topology"
    ) +
    theme_classic()
ggsave(file.path("figs", "constrained.pdf"), fig, width = 8, height = 3)
