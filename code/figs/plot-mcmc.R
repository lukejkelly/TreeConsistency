source("pars.R")
source(file.path("code", "figs", "R", "plot-utilities.R"))

s_seq <- c("kingman", "uniform")
for (s in s_seq) {
    plot_trace(s, n_seq, m_seq, k_seq, r_seq)
}
