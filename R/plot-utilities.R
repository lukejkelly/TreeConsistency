# helper function plot output with custom y label then save to figs directory
plot_support <- function(out, s, m_seq, k_seq) {
    fig_data <- out |>
        dplyr::group_by(n, m, k) |>
        dplyr::summarise(p_bar = mean(p)) |>
        dplyr::ungroup()
    y_lab <-
        sprintf(
            "$ \\Pi^{italic(%s,n)}(italic(T)_0 | bold(a)_1, ldots, bold(a)_{italic(k)}) $",
            toupper(substr(s, 1, 1))
        ) |>
        latex2exp::TeX()
    fig <- fig_data |>
        ggplot2::ggplot(ggplot2::aes(x = k, y = p_bar, color = as.factor(n))) +
        ggplot2::geom_line(alpha = 0.75) +
        ggplot2::scale_x_continuous(
            breaks = k_seq,
            trans = scales::log10_trans(),
            labels = scales::label_log(),
            minor_breaks = NULL
        ) +
        ggplot2::scale_y_continuous(limits = c(0, 1), minor_breaks = NULL) +
        ggplot2::labs(x = "k", y = y_lab, color = "n") +
        ggplot2::theme_light() +
        ggplot2::theme(
            legend.title.align = 0.5,
            axis.title.x = ggplot2::element_text(face = "italic"),
            legend.title = ggplot2::element_text(face = "italic")
        ) +
        ggplot2::facet_wrap(~ m, labeller = ggplot2::label_bquote(mu == .(m)))
    ggplot2::ggsave(
        file.path("figs", sprintf("support-%s.pdf", s)),
        fig,
        width = 3 * length(m_seq) + 2,
        height = 3
    )
    return(NULL)
}

plot_threshold <- function(out, s, n_seq, m_seq, k_seq) {
    fig_data <- out |>
       dplyr::group_by(n, m, k) |>
       dplyr::summarise(p_bar = mean(p)) |>
       dplyr::summarise(
            upper = min(k[p_bar >= 0.5]),
            lower = max(k[k < upper])
        ) |>
        dplyr::ungroup()
    fig <- fig_data |>
        ggplot2::ggplot(ggplot2::aes(x = n, y = k, color = as.factor(n))) +
        ggplot2::geom_errorbar(
            ggplot2::aes(ymin = lower, ymax = upper),
            position = ggplot2::position_dodge(width = 1),
            width = 0.75
        ) +
        ggplot2::scale_x_continuous(breaks = n_seq, minor_breaks = NULL) +
        ggplot2::scale_y_continuous(
            breaks = k_seq,
            trans = scales::log10_trans(),
            labels = scales::label_log(),
            limits = c(min(k_seq), max(k_seq)),
            minor_breaks = NULL
        ) +
        ggplot2::labs(x = "n", y = "k", color = "n") +
        ggplot2::theme_light() +
        ggplot2::theme(
            legend.title.align = 0.5,
            axis.title.x = ggplot2::element_text(face = "italic"),
            axis.title.y = ggplot2::element_text(face = "italic"),
            legend.title = ggplot2::element_text(face = "italic")
        ) +
        ggplot2::facet_wrap(~ m, labeller = ggplot2::label_bquote(mu == .(m)))
    ggplot2::ggsave(
        file.path("figs", sprintf("threshold-%s.pdf", s)),
        fig,
        width = 3 * length(m_seq) + 2,
        height = 3
    )
    return(NULL)
}

# plotting log-likelihood traces from mcmc
plot_trace <- function(s, n_seq, m_seq, k_seq, r_seq) {
    out <- tidyr::expand_grid(
        n = sort(n_seq),
        m = sort(m_seq),
        k = sort(k_seq),
        r = sort(r_seq),
        l = list(NULL)
    )
    for (i in seq_len(nrow(out))) {
        n <- out$n[i]
        m <- out$m[i]
        k <- out$k[i]
        r <- out$r[i]
        out$l[[i]] <-
            file.path(
                "out",
                sprintf("%s-n%s-m%s-k%s-r%s.log", s, n, m, k, r)
            ) |>
            readr::read_tsv(col_types = "iddd") |>
            dplyr::select(Iteration, Likelihood)
    }
    figs <- out |>
        tidyr::unnest(l) |>
        dplyr::group_by(n, m, k) |>
        dplyr::group_map(plot_trace_group)
    pdf(
        file.path("figs", sprintf("trace-%s.pdf", s)),
        width = 7,
        height = length(r_seq)
    )
    print(figs)
    dev.off()
    return(NULL)
}

plot_trace_group <- function(x, y) {
    fig <- x |>
        ggplot2::ggplot() +
        ggplot2::aes(x = Iteration, y = Likelihood) +
        ggplot2::geom_line() +
        ggplot2::facet_wrap(~ r, ncol = 1, scales = "free_y") +
        ggplot2::labs(
            title = sprintf("n = %s, m = %s, k = %s", y$n, y$m, y$k),
            y = "Log-likelihood"
        )
    return(fig)
}
