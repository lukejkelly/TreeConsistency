# helper functions for writing data and config files

write_data <- function(alleles, s, n, m, r, k) {
    alleles_k <- purrr::map(alleles, magrittr::extract, seq_len(k))
    temp_file <- tempfile()
    ape::write.nexus.data(alleles_k, temp_file, format = "standard")
    data_file <-
        temp_file |>
        readr::read_file() |>
        stringr::str_replace("symbols=\"0123456789\"", "symbols=\"01\"")
    readr::write_file(
        data_file,
        file.path("data", sprintf("%s-n%s-m%s-r%s-k%s.nex", s, n, m, r, k))
    )
    return(NULL)
}

write_config <- function(s, n, m, r, k) {
    config_template <- readr::read_file(file.path("Rev", "config-template.Rev"))
    config <- config_template |>
        stringr::str_replace(
            "_PATH_TO_DATA_",
            file.path("data", sprintf("%s-n%s-m%s-r%s-k%s.nex", s, n, m, r, k))
        ) |>
        stringr::str_replace(
            "_PATH_TO_TREE_PRIOR_",
            file.path("Rev", sprintf("tree-%s.Rev", s))
        ) |>
        stringr::str_replace(
            "_MUTATION_RATE_",
            as.character(m)
        ) |>
        stringr::str_replace(
            "_PATH_TO_LOG_",
            file.path("out", sprintf("%s-n%s-m%s-r%s-k%s.log", s, n, m, r, k))
        ) |>
        stringr::str_replace(
            "_PATH_TO_SAMPLED_TREES_",
            file.path("out", sprintf("%s-n%s-m%s-r%s-k%s.t", s, n, m, r, k))
        )
    readr::write_file(
        config,
        file.path("configs", sprintf("%s-n%s-m%s-r%s-k%s.Rev", s, n, m, r, k))
    )
    return(NULL)
}
