# helper function for simulating trees and data

write_tree <- function(tree, s) {
    n <- ape::Ntip(tree)
    ape::write.nexus(
        tree,
        file = file.path("trees", sprintf("%s-n%s.nex", s, n)),
        translate = FALSE
    )
    return(NULL)
}

write_alleles <- function(alleles_df, s, m) {
    alleles_list <- as.list(alleles_df)
    temp_file <- tempfile()
    ape::write.nexus.data(alleles_list, temp_file, "standard")
    data_file <- temp_file |>
        readr::read_file() |>
        stringr::str_replace("symbols=\"0123456789\"", "symbols=\"01\"")
    n <- length(alleles_list)
    readr::write_file(
        data_file,
        file.path("data", sprintf("%s-n%s-m%s.nex", s, n, m))
    )
    return(NULL)
}

get_inds_labs <- function(labs, tree) {
    # tip label indices of tree
    inds_labs <- purrr::map_int(labs, \(i) which(i == tree$tip.label))
    return(inds_labs)
}

get_inds_edge <- function(inds_labs, tree) {
    # tip label indices to edge indices
    inds_edge <- purrr::map_int(inds_labs, \(i) which(i == tree$edge[, 2]))
    return(inds_edge)
}

extend_leaves <- function(tree, labs, x) {
    # extend edges into labs by x units
    inds <- labs |>
        get_inds_labs(tree) |>
        get_inds_edge(tree)
    tree$edge.length[inds] <- tree$edge.length[inds] + x
    return(tree)
}

duplicate_alleles <- function(alleles, from, to) {
    # identical offspring after a branching event indexed by tip label
    alleles[to] <- alleles[from]
    return(alleles)
}

mutate_alleles <- function(alleles, labs, delta) {
    # advance mutation process by delta units along branches into tips labs
    # inspired by phangorn::simSeq
    levels <- c("0", "1")
    p <- (1 + exp(-2 * delta)) / 2
    for (i in labs) {
        j0 <- alleles[[i]] == "0"
        j1 <- alleles[[i]] == "1"
        alleles[[i]][j0] <- sample(levels, sum(j0), TRUE, c(p, 1 - p))
        alleles[[i]][j1] <- sample(levels, sum(j1), TRUE, c(1 - p, p))
    }
    return(alleles)
}
