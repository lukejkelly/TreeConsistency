# process raw data into subsets of each length k in k_seq

# setting up
source("pars.R")
source(file.path("code", "data", "R", "process-utilities.R"))

# reading each raw dataset and writing subsets of length k
pb <- progress::progress_bar$new(total = length(s_seq) * length(n_seq))
for (s in s_seq) {
    for (n in n_seq) {
        pb$tick()
        for (m in m_seq) {
            for (r in r_seq) {
                process_data(s, n, m, k_seq, r)
            }
        }
    }
}
