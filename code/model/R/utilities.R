# helper functions for writing revbayes config files

write_config <- function(s, n, m, k, r) {
    # s: type of tree is either "kingman" if coalescent or "uniform" if unrooted
    # n: number of leaves
    # m: mutation rate in JC69 model used to generate data
    # k: number of sites at which alleles were generated
    # r: replication index
    template <- readr::read_file(
        file.path("code", "model", "Rev", "config-template.Rev")
    )
    config <- template |>
        stringr::str_replace(
            "_PATH_TO_DATA_",
            file.path(
                "data",
                "proc",
                sprintf("%s-n%s-m%s-k%s-r%s.nex", s, n, m, k, r)
            )
        ) |>
        stringr::str_replace(
            "_PATH_TO_TREE_PRIOR_",
            file.path("code", "model", "Rev", sprintf("tree-%s.Rev", s))
        ) |>
        stringr::str_replace(
            "_MUTATION_RATE_",
            as.character(m)
        ) |>
        stringr::str_replace(
            "_PATH_TO_LOG_",
            file.path("out", sprintf("%s-n%s-m%s-k%s-r%s.log", s, n, m, k, r))
        ) |>
        stringr::str_replace(
            "_PATH_TO_SAMPLED_TREES_",
            file.path("out", sprintf("%s-n%s-m%s-k%s-r%s.t", s, n, m, k, r))
        )
    readr::write_file(
        config,
        file.path("run", sprintf("%s-n%s-m%s-k%s-r%s.Rev", s, n, m, k, r))
    )
    return(NULL)
}
