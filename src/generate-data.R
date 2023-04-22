# sample a coalescent tree with n leaves then generate data at k sites from a
# JC69 model with mutation rate mu

args = commandArgs(trailingOnly = TRUE)
if (length(args) != 3) {
    stop("R -f src/generate-data.R --args n_taxa n_sites r_mutation")
}
N <- as.integer(args[1])
K <- as.integer(args[2])
mu <- as.double(args[3])

readr::write_lines(
    list(paste("N <- ", N), paste("K <- ", K), paste("mu <-", mu)),
    file = "finitesites-pars.R"
)

tree <- ape::rcoal(N)
ape::write.nexus(tree, file = "finitesites-tree.nex", translate = FALSE)

alleles <- phangorn::simSeq(
    tree,
    l = K,
    type = "USER",
    levels = c("0", "1"),
    rate = mu
)
temp_file <- tempfile()
phangorn::write.phyDat(alleles, temp_file, "nexus", "USER")
data_file <- temp_file |>
    readr::read_file() |>
    stringr::str_remove("symbols=\"0123456789\"")
readr::write_file(data_file, "finitesites-data.nex")
