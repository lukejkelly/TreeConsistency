# sequences of taxa count n, mutation rate m, site count k, replicate index r
n_seq <- seq.int(4, 8, 1)
m_seq <- c(0.25, 0.5, 1, 2)
k_seq <- 10^seq.int(0, 4)
r_seq <- seq_len(10)

# n_seq <- seq.int(4, 16, 3)
# m_seq <- c(0.1, 0.2, 0.4)
# k_seq <- 10^seq.int(0, 5)
# r_seq <- seq_len(25)
