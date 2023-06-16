# set up constrained and unconstrained RevBayes analyses
# taxa are shuffled so that subsampled leaves are further apart

source("pars.R")
source(file.path("R", "setup-utilities.R"))

s_seq <- c("kingman", "uniform")
K <- max(k_seq)
pb <- progress::progress_bar$new(total = length(s_seq) * length(n_seq))
for (s in s_seq) {
    for (n in n_seq) {
        for (m in m_seq) {
            for (r in r_seq) {
                alleles <-
                    file.path(
                        "raw",
                        sprintf("%s-n%s-m%s-k%s-r%s.nex", s, n, m, K, r)
                    ) |>
                    ape::read.nexus.data()
                for (k in k_seq) {
                    write_data(alleles, s, n, m, k, r)
                    write_config(s, n, m, k, r)
                }
            }
        }
        pb$tick()
    }
}
