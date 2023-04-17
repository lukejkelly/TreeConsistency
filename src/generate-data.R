# sample a coalescent tree with n leaves then generate data at k sites from a
# JC69 model with mutation rate mu

library("ape")
library("phangorn")
library("readr")
library("stringr")

args = commandArgs(trailingOnly = TRUE)
if (length(args) != 3) {
    stop("R -f src/generate-data.R --args n_taxa n_sites r_mutation")
}
N <- as.integer(args[1])
K <- as.integer(args[2])
mu <- as.double(args[3])

write_lines(
    list(paste("N <- ", N), paste("K <- ", K), paste("mu <-", mu)),
    file = "finitesites-pars.R"
)

tree <- rcoal(N)
write.nexus(tree, file = "finitesites-tree.nex", translate = FALSE)

alleles <- simSeq(tree, l = K, type = "USER", levels = c("0", "1"), rate = mu)
temp_file <- tempfile()
write.phyDat(alleles, temp_file, "nexus", "USER")
data_file <- temp_file |>
    read_file() |>
    str_remove("symbols=\"0123456789\"")
write_file(data_file, "finitesites-data.nex")
