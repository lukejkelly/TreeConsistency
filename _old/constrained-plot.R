library("readr")
library("dplyr")
library("purrr")
library("tidyr")
library("scales")
library("ggplot2")

source(file.path("src", "finitesites-pars.R"))

leaf_inds <- 1:n
merg_inds <- 2 * n

# convert logical to leaf indices
leaf_labels <- function(x) {
    y <- unlist(x, use.names = FALSE) |> which()
    leaf_labs <- sprintf("%i,%i", y[1], y[2])
    return(leaf_labs)
}

# get first coalescent pair relative frequencies for each experiment
for (j in seq_along(k_seq)) {
    k <- k_seq[j]
    out_k <- read_delim(
        file.path("out", sprintf("constrained-%i.txt", k)),
        delim = " ",
        col_names = FALSE,
        col_types = cols(.default = "i"),
        skip = burnin,
        progress = FALSE
    )
    out_k1 <- out_k |> select(all_of(leaf_inds))
    out_k2 <- out_k |> pull(merg_inds)

    res_k <- map_dfc(out_k1, ~ . == out_k2) |>
        group_by_all() |>
        tally() |>
        ungroup() |>
        mutate(p = n / sum(n)) |>
        nest(f = all_of(leaf_inds)) |>
        mutate(l = map_chr(f, leaf_labels))

    fcp_k <- tibble(k = k, l = res_k$l, p = res_k$p)
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
        x = "Number of sites k",
        y = "Posterior support",
        fill = NULL,
        title = "Posterior on first coalescent pair"
    ) +
    theme_classic() +
    scale_fill_brewer()
ggsave(file.path("figs", "constrained.pdf"), fig, width = 8, height = 3)
