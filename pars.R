# types of trees to generate
s_seq <- c("kingman", "uniform")

# sequence of taxa counts n
n_seq <- seq.int(4, 12, 3)

# sequence of mutation rates m
m_seq <- c(0.5, 0.75, 1, 1.25, 1.5)

# sequence of site counts k
k_seq <- 10^seq.int(0, 4)

# replication indices
r_seq <- seq_len(100)

# n_seq <- seq.int(4, 16, 3)
# m_seq <- c(0.1, 0.2, 0.4)
# k_seq <- 10^seq.int(0, 5)
# r_seq <- seq_len(25)
