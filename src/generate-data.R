# sample trees with n = 4, 8, ..., N leaves then generate data at K sites from a
# JC69 model with mutation rate mu

source(file.path("src", "generate-functions.R"))

args = commandArgs(trailingOnly = TRUE)
if (length(args) != 4) {
    stop("R -f src/generate-data.R --args tree_type n_taxa n_sites r_mutation")
}
s <- args[1]
N <- as.integer(args[2])
K <- as.integer(args[3])
mu <- as.double(args[4])

readr::write_lines(
    list(paste("N <-", N), paste("K <-", K), paste("mu <-", mu)),
    file = file.path("pars", sprintf("%s.R", s))
)

source(file.path("src", "sequences.R"))
for (n in n_seq) {
    sample_tree_data(s, n, K, mu)
}
