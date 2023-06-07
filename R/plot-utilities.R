# helper function plot output with custom y label then save to figs directory
plot_support <- function(out, s, m_seq, k_seq) {
    y_lab <-
        sprintf(
            "$ \\Pi^{italic(%s,n)}(italic(T)_0 | bold(a)_1, ldots, bold(a)_{italic(k)}) $",
            toupper(substr(s, 1, 1))
        ) |>
        latex2exp::TeX()
    fig <- out |>
        ggplot2::ggplot(ggplot2::aes(x = k, y = p, color = as.factor(n))) +
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
        ggplot2::facet_wrap(
            ~ mu,
            1,
            labeller = ggplot2::label_bquote(mu == .(mu))
        )
    ggplot2::ggsave(
        file.path("figs", sprintf("support-%s.pdf", s)),
        fig,
        width = 3 * length(m_seq) + 2,
        height = 3
    )
    return(NULL)
}

plot_threshold <- function(out, s, n_seq, m_seq, k_seq) {
    fig <-
        out |>
        dplyr::nest_by(n, mu) |>
        dplyr::mutate(
            upper = min(data$k[data$p >= 0.5]),
            lower = max(data$k[data$k < upper])
        ) |>
        # dplyr::mutate(mu = as.factor(mu)) |>
        # ggplot2::ggplot(ggplot2::aes(x = n, y = k, color = mu)) +
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
        ggplot2::facet_wrap(
            ~ mu,
            1,
            labeller = ggplot2::label_bquote(mu == .(mu))
        )
    ggplot2::ggsave(
        file.path("figs", sprintf("threshold-%s.pdf", s)),
        fig,
        width = 3 * length(m_seq) + 2,
        height = 3
    )
    return(NULL)
}
