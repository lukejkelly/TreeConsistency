# types of trees to generate
s_seq <- c("kingman", "uniform")

# sequence of taxa counts n
n_seq <- seq.int(4, 8, 1)

# sequence of mutation rates m
m_seq <- c(0.25, 0.5, 1, 2)

# sequence of site counts k
k_seq <- 10^seq.int(0, 2)

# replication indices
r_seq <- seq_len(2)

# n_seq <- seq.int(4, 16, 3)
# m_seq <- c(0.1, 0.2, 0.4)
# k_seq <- 10^seq.int(0, 5)
# r_seq <- seq_len(25)
