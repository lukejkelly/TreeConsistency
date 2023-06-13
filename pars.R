# sequences of n taxa, k sites and mutation rate m, index of replicates r
n_seq <- seq.int(4, 12, 1)
m_seq <- c(0.01, 0.1, 1)
k_seq <- 10^seq.int(0, 2)
r_seq <- seq_len(2)
