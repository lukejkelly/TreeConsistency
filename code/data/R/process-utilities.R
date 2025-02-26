# helper functions for processing raw data into subsequences

read_raw_data <- function(s, n, m, k, r) {
    # read nexus data and return a list of sequences
    # s: type of tree is either "kingman" if coalescent or "uniform" if unrooted
    # n: number of leaves
    # m: mutation rate in JC69 model used to generate data
    # k: number of sites at which alleles were generated
    # r: replication index
    alleles <-
        file.path(
            "data",
            "raw",
            sprintf("%s-n%s-m%s-k%s-r%s.nex", s, n, m, k, r)
        ) |>
        ape::read.nexus.data()
    return(alleles)
}

write_proc_data <- function(alleles, s, n, m, k, r) {
    # extract the first k alleles in each list and write in nexus format
    # alleles: a list of sequences output by read_raw_data
    # s: type of tree is either "kingman" if coalescent or "uniform" if unrooted
    # n: number of leaves
    # m: mutation rate in JC69 model used to generate data
    # k: number of sites at which alleles were generated
    # r: replication index
    alleles_k <- purrr::map(alleles, magrittr::extract, seq_len(k))
    temp_file <- tempfile()
    ape::write.nexus.data(alleles_k, temp_file, format = "standard")
    data_file <-
        temp_file |>
        readr::read_file() |>
        stringr::str_replace("symbols=\"0123456789\"", "symbols=\"01\"")
    readr::write_file(
        data_file,
        file.path(
            "data",
            "proc",
            sprintf("%s-n%s-m%s-k%s-r%s.nex", s, n, m, k, r)
        )
    )
    return(NULL)
}

process_data <- function(s, n, m, k_seq, r) {
    # wrapper function to read raw data and write subsets to file
    # s: type of tree is either "kingman" if coalescent or "uniform" if unrooted
    # n: number of leaves
    # m: mutation rate in JC69 model used to generate data
    # k: number of sites at which alleles were generated
    # r: replication index
    k_max <- max(k_seq)
    alleles <- read_raw_data(s, n, m, k_max, r)
    for (k in k_seq) {
        write_proc_data(alleles, s, n, m, k, r)
    }
    return(NULL)
}
