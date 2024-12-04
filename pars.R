# types of trees to generate
s_seq <- c("kingman", "uniform")

# sequence of taxa counts n
n_seq <- seq.int(4, 16, 3)

# sequence of mutation rates m
m_seq <- c(0.0125, 0.025, 0.05, 0.1)

# sequence of site counts k
k_seq <- 10^seq.int(0, 5)

# replication indices
r_seq <- seq_len(100)

