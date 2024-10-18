# set up mcmc analyses

source("pars.R")
source(file.path("code", "model", "R", "utilities.R"))

k_max <- max(k_seq)
pb <- progress::progress_bar$new(total = length(s_seq) * length(n_seq))
for (s in s_seq) {
    for (n in n_seq) {
        pb$tick()
        for (m in m_seq) {
            for (r in r_seq) {
                for (k in k_seq) {
                    write_config(s, n, m, k, r)
                }
            }
        }
    }
}
