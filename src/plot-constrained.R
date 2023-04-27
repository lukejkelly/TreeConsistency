library("ggplot2")

source(file.path("pars", "constrained.R"))
source(file.path("src", "sequences.R"))

out <- tidyr::expand_grid(n = n_seq, k = k_seq, p = NA_real_)
for (i in seq_len(nrow(out))) {
    svMisc::progress(i, nrow(out))
    n <- out$n[i]
    k <- out$k[i]
    tree0 <- file.path("trees", sprintf("constrained-n%s.nex", n)) |>
        ape::read.nexus()
    trees <- file.path("out", sprintf("constrained-n%s-k%s.t", n, k)) |>
        ape::read.tree() |>
        magrittr::extract(-1)
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
        x = "k",
        y = latex2exp::TeX("$ \\Pi^K(T_0 | bold(a)_1, ldots, bold(a)_k) $"),
        color = "n"
    ) +
    theme_classic()
ggsave(file.path("figs", "constrained.pdf"), fig, width = 8, height = 3)
