# helper functions for simulating data

simulate_alleles <- function(tree, mutation_rate, n_sites) {
    # simulate alleles from the JC69 model on input tree
    # tree: class "phylo" tree object
    # mutation_rate: mutation rate in JC69 model with binary states
    # n_sites: number of sites at which to generate alleles
    alleles <-
        phangorn::simSeq(
            tree,
            l = n_sites,
            type = "USER",
            levels = c("0", "1"),
            rate = mutation_rate
        ) |>
        as.data.frame()
    return(alleles)
}

write_alleles <- function(alleles_df, s, n, m, k, r) {
    # write alleles in nexus format to data/raw after correcting the symbol list
    # alleles_df: data frame of alleles output by simulate_alleles() on tree of
    #   type s with n leaves
    # s: type of tree is either "kingman" if coalescent or "uniform" if unrooted
    # n: number of leaves
    # m: mutation rate in JC69 model used to generate data
    # k: number of sites at which alleles were generated
    # r: replication index
    alleles_list <- as.list(alleles_df)
    temp_file <- tempfile()
    ape::write.nexus.data(alleles_list, temp_file, "standard")
    data_file <-
        temp_file |>
        readr::read_file() |>
        stringr::str_replace("symbols=\"0123456789\"", "symbols=\"01\"")
    readr::write_file(
        data_file,
        file.path(
            "data",
            "raw",
            sprintf("%s-n%s-m%s-k%s-r%s.nex", s, n, m, k, r)
        )
    )
    return(NULL)
}

simulate_and_write_alleles <- function(s, n_seq, m_seq, k_seq, r_seq) {
    # simulate alleles from the JC69 model on a grid of trees, mutation rates
    # and replication indices
    # s: type of tree is either "kingman" if coalescent or "uniform" if unrooted
    # n_seq: sequence of numbers of leaves for which trees have been generated
    # m_seq: sequence of mutation rates for JC69 models used to generate data
    # k_seq: sequence of numbers of sites, in practice alleles are generated at
    #   max(k_seq) sites and the other data sets are increasing subsets
    # r_seq: sequence of replication indices
    k_max <- max(k_seq)
    pb <- progress::progress_bar$new(total = length(n_seq) * length(m_seq))
    for (n in n_seq) {
        tree <-
            file.path("trees", sprintf("%s-n%s.nex", s, n)) |>
            ape::read.nexus()
        for (m in m_seq) {
            pb$tick()
            for (r in r_seq) {
                alleles <- simulate_alleles(tree, m, k_max)
                write_alleles(alleles, s, n, m, k_max, r)
            }
        }
    }
    return(NULL)
}
