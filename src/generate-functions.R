# helper function for simulating trees and data

sample_tree_data <- function(s, n, k, mu) {
    if (stringr::str_equal(s, "constrained")) {
        tree <- ape::rcoal(n)
    } else if (stringr::str_equal(s, "unconstrained")) {
        tree <- ape::rtree(n, rooted = FALSE, br = rexp)
    } else {
        stop("s must be \"constrained\" or \"unconstrained\": s = ", s)
    }
    ape::write.nexus(
        tree,
        file = file.path("trees", sprintf("%s-n%s.nex", s, n)),
        translate = FALSE
    )
    alleles <- phangorn::simSeq(
        tree,
        l = k,
        type = "USER",
        levels = c("0", "1"),
        rate = mu
    )
    temp_file <- tempfile()
    phangorn::write.phyDat(alleles, temp_file, "nexus", "USER")
    data_file <- temp_file |>
        readr::read_file() |>
        stringr::str_replace("symbols=\"0123456789\"", "symbols=\"01\"")
    n <- length(alleles)
    readr::write_file(
        data_file,
        file.path("data", sprintf("%s-n%s.nex", s, n))
    )
    return(NULL)
}
