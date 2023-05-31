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
            labels = scales::label_log()
        ) +
        ggplot2::labs(x = "k", y = y_lab, color = "n") +
        ggplot2::theme_light() +
        ggplot2::theme(
            legend.title.align = 0.5,
            axis.title.x = ggplot2::element_text(face = "italic"),
            legend.title = ggplot2::element_text(face = "italic")
        ) +
        ggplot2::facet_wrap(~ mu, 1, labeller = ggplot2::label_bquote(mu == .(mu)))
    ggplot2::ggsave(
        file.path("figs", sprintf("%s.pdf", s)),
        fig,
        width = 3 * length(m_seq) + 2,
        height = 3
    )
    return(NULL)
}
