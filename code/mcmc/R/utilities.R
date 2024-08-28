# helper functions for writing data and config files

write_data <- function(alleles, s, n, m, k, r) {
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

write_config <- function(s, n, m, k, r) {
    template <- readr::read_file(file.path("Rev", "config-template.Rev"))
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
            file.path("Rev", sprintf("tree-%s.Rev", s))
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
