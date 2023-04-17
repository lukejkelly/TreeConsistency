# helper functions for writing (sub)tree, data and config files

write_tree <- function(tree, taxa, n) {
    sub_taxa <- taxa[seq_len(n)]
    sub_tree <- castor::get_subtree_with_tips(tree, sub_taxa) |>
        purrr::pluck("subtree")
    write.nexus(
        sub_tree,
        file = file.path("trees", sprintf("finitesites-n%s.nex", n)),
        translate = FALSE
    )
    return(NULL)
}

write_data <- function(alleles, n, k) {
    alleles_nk <- alleles |>
        dplyr::select(seq_len(n)) |>
        dplyr::slice(seq_len(k))
    temp_file <- tempfile()
    ape::write.nexus.data(alleles_nk, temp_file, format = "standard")
    data_file <- temp_file |>
        readr::read_file() |>
        stringr::str_remove("symbols=\"0123456789\"")
    readr::write_file(
        data_file,
        file.path("data", sprintf("finitesites-n%s-k%s.nex", n, k))
    )
    return(NULL)
}

write_config <- function(s, n, k) {
    config <- readr::read_file(file.path("src", sprintf("%s-template.mb", s)))
    config_nk <- stringr::str_replace_all(
        config,
        "XYZ",
        sprintf("n%s-k%s", n, k)
    )
    readr::write_file(
        config_nk,
        file.path("configs", sprintf("%s-n%s-k%s.mb", s, n, k))
    )
    return(NULL)
}
