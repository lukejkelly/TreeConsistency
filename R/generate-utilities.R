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

simulate_alleles <- function(tree, mutation_rate, n_sites) {
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

write_alleles <- function(alleles_df, s, n, m, r) {
    alleles_list <- as.list(alleles_df)
    temp_file <- tempfile()
    ape::write.nexus.data(alleles_list, temp_file, "standard")
    data_file <- temp_file |>
        readr::read_file() |>
        stringr::str_replace("symbols=\"0123456789\"", "symbols=\"01\"")
    readr::write_file(
        data_file,
        file.path("data", sprintf("%s-n%s-m%s-r%s.nex", s, n, m, r))
    )
    return(NULL)
}

simulate_and_write_alleles <- function(tree, s, m_seq, k_seq, r_seq) {
    K <- max(k_seq)
    for (m in m_seq) {
        for (r in r_seq) {
            alleles <- simulate_alleles(tree, m, K)
            write_alleles(alleles, s, n, m, r)
        }
    }
    return(NULL)
}

# get_inds_labs <- function(labs, tree) {
#     # tip label indices of tree
#     inds_labs <- purrr::map_int(labs, \(i) which(i == tree$tip.label))
#     return(inds_labs)
# }
#
# get_edge <- function(inds, tree) {
#     # node indices to edge indices
#     inds_edge <- purrr::map_int(inds, \(i) which(i == tree$edge[, 2]))
#     return(inds_edge)
# }

# extend_leaves <- function(tree, x) {
#     # extend leaf edges by x units
#     inds <- which(tree$edge[, 2] %in% seq_along(tree$tip.label))
#     tree$edge.length[inds] <- tree$edge.length[inds] + x
#     return(tree)
# }

grow_kingman <- function(tree_old, n, i, x) {
    # create sibling of leaf i and extend all edges into leaves by x units
    tree_new <- TreeTools::AddTip(tree_old, i, paste0("t", n + 1), 0, 0)
    ind_leaves <- seq_len(n + 1)
    edge_leaves <- which(tree_new$edge[, 2] %in% ind_leaves)
    tree_new$edge.length[edge_leaves] <- tree_new$edge.length[edge_leaves] + x
    return(tree_new)
}

grow_uniform <- function(tree_old, n, b, i, x) {
    # from branch b detach node b[i[2]] and replace by new_node with edges of
    # length x[1] to node b[i[2]] and of length x[2] to new_node
    #                                                        __x[1]__ b[i[2]] ..
    # .. b[i[1]] __ b[i[2]] ..  -->  .. b[i[1]] __ new_node_|
    #                                                       |__x[2]__ new_leaf
    new_leaf <- n + 1L
    new_node <- 2L * n
    # increment node indices by 1 to accommodate new leaf
    edge <- rbind(tree_old$edge, integer(2), integer(2))
    edge[edge > n] <- edge[edge > n] + 1L
    edge[2 * n - 2, i] <- c(new_node, edge[b, i[2]])
    edge[2 * n - 1, ] <- c(new_node, new_leaf)
    edge[b, i[2]] <- new_node
    # new edges at end of edge and edge.length, ditto new_node in tip.label
    tree_new <- list(
        edge = edge,
        edge.length = c(tree_old$edge.length, x),
        Nnode = tree_old$Nnode + 1L,
        tip.label = c(tree_old$tip.label, paste0("t", new_leaf))
    )
    class(tree_new) <- "phylo"
    return(tree_new)
}

# duplicate_alleles <- function(alleles, from, to) {
#     # identical offspring after a branching event indexed by tip label
#     alleles[to] <- alleles[from]
#     return(alleles)
# }
#
# mutate_alleles <- function(alleles, labs, delta) {
#     # advance mutation process by delta units along branches into tips labs
#     # inspired by phangorn::simSeq
#     levels <- c("0", "1")
#     p <- (1 + exp(-2 * delta)) / 2
#     for (i in labs) {
#         j0 <- alleles[[i]] == "0"
#         j1 <- alleles[[i]] == "1"
#         alleles[[i]][j0] <- sample(levels, sum(j0), TRUE, c(p, 1 - p))
#         alleles[[i]][j1] <- sample(levels, sum(j1), TRUE, c(1 - p, p))
#     }
#     return(alleles)
# }
