# on each tree generate alleles at max(k_seq) sites from a JC69 model for each
# mutation rate in m_seq and replication index in r_seq

# setting up
source("pars.R")
source(file.path("code", "data", "R", "generate-utilities.R"))

# generate independent data sets for each mutation rate and replication index
for (s in s_seq) {
    generate_data(s, n_seq, m_seq, k_seq, r_seq)
}
