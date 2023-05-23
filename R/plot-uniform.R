library("ggplot2")

source(file.path("pars", "uniform.R"))
source(file.path("R", "utilities.R"))

out <- tidyr::expand_grid(n = n_seq(N), k = k_seq(J), p = NA_real_)
for (i in seq_len(nrow(out))) {
    svMisc::progress(i, nrow(out))
    n <- out$n[i]
    k <- out$k[i]
    tree0 <- file.path("trees", sprintf("uniform-n%s.nex", n)) |>
        ape::read.nexus() |>
        ape::unroot()
    trees <- file.path("out", sprintf("uniform-n%s-k%s.t", n, k)) |>
        ape::read.tree() |>
        magrittr::extract(-1) |>
        ape::unroot()
    topology <- logical(length(trees))
    for (j in seq_along(topology)) {
        topology[j] <- ape::all.equal.phylo(tree0, trees[[j]], FALSE)
    }
    out$p[i] <- mean(topology)
}

fig <- out |>
    ggplot(aes(x = k, y = p, color = as.factor(n))) +
    geom_line() +
    scale_x_continuous(
        breaks = k_seq(J),
        trans = scales::log_trans(2),
        labels = scales::label_log(2)
    ) +
    labs(
        x = "k",
        y = latex2exp::TeX("$ \\Pi^{italic(U,n)}(italic(T)_0 | bolditalic(a)_1, ldots, bolditalic(a)_k) $"),
        color = "n"
    ) +
    theme_classic() +
    theme(legend.title.align = 0.5)
ggsave(file.path("figs", "uniform.pdf"), fig, width = 8, height = 3)
