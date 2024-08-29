# set up mcmc analyses

source("pars.R")
source(file.path("code", "mcmc", "R", "utilities.R"))

s_seq <- c("kingman", "uniform")
k_max <- max(k_seq)
pb <- progress::progress_bar$new(total = length(s_seq) * length(n_seq))
for (s in s_seq) {
    for (n in n_seq) {
        pb$tick()
        for (m in m_seq) {
            for (r in r_seq) {
                # alleles <-
                #     file.path(
                #         "data",
                #         "raw",
                #         sprintf("%s-n%s-m%s-k%s-r%s.nex", s, n, m, k_max, r)
                #     ) |>
                #     ape::read.nexus.data()
                for (k in k_seq) {
                    # write_data(alleles, s, n, m, k, r)
                    write_config(s, n, m, k, r)
                }
            }
        }
    }
}
