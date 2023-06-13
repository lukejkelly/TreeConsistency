# sequences of: no. taxa n, mutation rate m, replicate index r, no. sites k
n_seq <- seq.int(4, 16, 3)
m_seq <- c(0.01, 0.1, 1)
r_seq <- seq_len(10)
k_seq <- 10^seq.int(0, 5)
