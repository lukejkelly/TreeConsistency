source("pars.R")
source(file.path("R", "plot-utilities.R"))
s <- "uniform"

out <- tidyr::expand_grid(
    m = sort(m_seq),
    n = sort(n_seq),
    k = sort(k_seq),
    r = sort(r_seq),
    p = NA_real_
)
for (i in seq_len(nrow(out))) {
    m <- out$m[i]
    n <- out$n[i]
    k <- out$k[i]
    r <- out$r[i]
    tree0 <- file.path("trees", sprintf("%s-n%s.nex", s, n)) |>
        ape::read.nexus() |>
        ape::unroot()
    trees <- file.path("out", sprintf("%s-n%s-m%s-r%s-k%s.t", s, n, m, r, k)) |>
        ape::read.tree() |>
        magrittr::extract(-1) |>
        ape::unroot()
    topology <- logical(length(trees))
    for (j in seq_along(topology)) {
        topology[j] <- ape::all.equal.phylo(tree0, trees[[j]], FALSE)
    }
    out$p[i] <- mean(topology)
}
plot_support(out, s, m_seq, k_seq)
plot_threshold(out, s, m_seq, n_seq, k_seq)
