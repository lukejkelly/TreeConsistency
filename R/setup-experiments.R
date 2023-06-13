# set up constrained and unconstrained RevBayes analyses
# taxa are shuffled so that subsampled leaves are further apart

source("pars.R")
source(file.path("R", "setup-utilities.R"))

s_seq <- c("kingman", "uniform")
for (s in s_seq) {
    for (n in n_seq) {
        for (m in m_seq) {
            alleles <- ape::read.nexus.data(
                file.path("data", sprintf("%s-n%s-m%s.nex", s, n, m))
            )
            for (k in k_seq) {
                write_data(alleles, s, n, m, k)
                write_config(s, n, m, k)
            }
        }
    }
}
