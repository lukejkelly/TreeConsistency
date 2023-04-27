# helper functions for writing data and config files

write_data <- function(alleles, s, n, k) {
    alleles_k <- alleles |>
        purrr::map(magrittr::extract, seq_len(k))
    temp_file <- tempfile()
    ape::write.nexus.data(alleles_k, temp_file, format = "standard")
    data_file <- temp_file |>
        readr::read_file() |>
        stringr::str_replace("symbols=\"0123456789\"", "symbols=\"01\"")
    readr::write_file(
        data_file,
        file.path("data", sprintf("%s-n%s-k%s.nex", s, n, k))
    )
    return(NULL)
}

write_config <- function(s, n, k, mu) {
    config_template <- file.path("src", "config-template.Rev") |>
        readr::read_file()
    config <- config_template |>
        stringr::str_replace(
            "_PATH_TO_DATA_",
            file.path("data", sprintf("%s-n%s-k%s.nex", s, n, k))
        ) |>
        stringr::str_replace(
            "_PATH_TO_TREE_PRIOR_",
            file.path("src", sprintf("tree-%s.Rev", s))
        ) |>
        stringr::str_replace(
            "_MUTATION_RATE_",
            as.character(mu)
        ) |>
        stringr::str_replace(
            "_PATH_TO_LOG_",
            file.path("out", sprintf("%s-n%s-k%s.log", s, n, k))
        ) |>
        stringr::str_replace(
            "_PATH_TO_SAMPLED_TREES_",
            file.path("out", sprintf("%s-n%s-k%s.t", s, n, k))
        )
    readr::write_file(
        config,
        file.path("configs", sprintf("%s-n%s-k%s.Rev", s, n, k))
    )
    return(NULL)
}
