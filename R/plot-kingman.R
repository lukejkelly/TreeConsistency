source("pars.R")
source(file.path("R", "plot-utilities.R"))
s <- "kingman"

out <- tidyr::expand_grid(
    n = sort(n_seq),
    m = sort(m_seq),
    k = sort(k_seq),
    r = sort(r_seq),
    p = NA_real_
)
pb <- progress::progress_bar$new(total = nrow(out))
for (i in seq_len(nrow(out))) {
    pb$tick()
    n <- out$n[i]
    m <- out$m[i]
    k <- out$k[i]
    r <- out$r[i]
    tree0 <- file.path("trees", sprintf("%s-n%s.nex", s, n)) |>
        ape::read.nexus()
    trees <- file.path("out", sprintf("%s-n%s-m%s-k%s-r%s.t", s, n, m, k, r)) |>
        ape::read.tree() |>
        magrittr::extract(-1)
    topology <- logical(length(trees))
    for (j in seq_along(topology)) {
        topology[j] <- ape::all.equal.phylo(tree0, trees[[j]], FALSE)
    }
    out$p[i] <- mean(topology)
}
plot_support(out, s, m_seq, k_seq)
plot_support_all(out, s, m_seq, k_seq, r_seq)
plot_threshold(out, s, n_seq, m_seq, k_seq)
