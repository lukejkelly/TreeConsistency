library("readr")
library("dplyr")
# library("purrr")
library("magrittr")
library("tidyr")
library("scales")
library("ggplot2")
library("ape")

source("src/finitesites-pars.R")

# get first coalescent pair relative frequencies for each experiment
for (j in seq_along(k_seq)) {
    k <- k_seq[j]
    out_k <- sprintf("out/unconstrained-%i.t", k) |>
        read.nexus() |>
        magrittr::extract(-seq_len(1 + burnin))
    spl_k <- prop.part(out_k)

    n_samp <- length(out_k)
    n_spl <- length(spl_k)

    spl_names <- character(n_spl)
    ind_ignore <- which(sapply(spl_k, length) == n)
    tip_labels <- spl_k[[ind_ignore]]
    for (i in seq_len(n_spl)) {
        if (i != ind_ignore) {
            spl_k_i <- spl_k[[i]]
            t_k1 <- spl_k_i |> sort() |> paste(collapse = ",")
            t_k2 <- tip_labels[-spl_k_i] |> sort() |> paste(collapse = ",")
            spl_names[i] <- c(t_k1, t_k2) |>
                sort() |>
                paste(collapse = "|")
        }
    }
    spl_freqs <- attr(spl_k, "number") / n_samp

    fcp_k <- tibble(
        k = k,
        l = spl_names[-ind_ignore],
        p = spl_freqs[-ind_ignore]
    )
    if (j == 1) {
        fcp <- fcp_k
    } else {
        fcp <- bind_rows(fcp, fcp_k)
    }
}

# make figure
fig <- fcp |>
    ggplot(aes(x = k, y = p, fill = l)) +
    geom_area() +
    scale_x_continuous(breaks = k_seq, trans = "log2") +
    labs(
        x = "number of sites k",
        y = "posterior support",
        fill = NULL,
        title = "posterior on splits"
    ) +
    theme_light()
ggsave("figs/unconstrained.pdf", fig)
