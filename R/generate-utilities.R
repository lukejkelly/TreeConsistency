# helper function for simulating trees and data

write_tree <- function(tree, s, n) {
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

write_alleles <- function(alleles_df, s, n, m, k, r) {
    alleles_list <- as.list(alleles_df)
    temp_file <- tempfile()
    ape::write.nexus.data(alleles_list, temp_file, "standard")
    data_file <- temp_file |>
        readr::read_file() |>
        stringr::str_replace("symbols=\"0123456789\"", "symbols=\"01\"")
    readr::write_file(
        data_file,
        file.path("raw", sprintf("%s-n%s-m%s-k%s-r%s.nex", s, n, m, k, r))
    )
    return(NULL)
}

simulate_and_write_alleles <- function(s, n_seq, m_seq, k_seq, r_seq) {
    K <- max(k_seq)
    pb <- progress::progress_bar$new(total = length(n_seq) * length(m_seq))
    for (n in n_seq) {
        tree <- ape::read.nexus(sprintf("trees/%s-n%s.nex", s, n))
        for (m in m_seq) {
            for (r in r_seq) {
                alleles <- simulate_alleles(tree, m, K)
                write_alleles(alleles, s, n, m, K, r)
            }
            pb$tick()
        }
    }
    return(NULL)
}

grow_kingman <- function(tree_old, n, i, x) {
    # create sibling of leaf i and extend all edges into leaves by x units
    # .. ___[l1]___ 1       .. __________[l1 + x]___________ 1
    # ..                    ..
    # .. ___[li]___ i  -->  .. ___[li]___ new_node ___[x]___ i
    # ..                                          |___[x]___ new_leaf
    # ..
    # .. ___[ln]___ n       .. __________[ln + x]___________ n
    b <- which(tree_old$edge[, 2] == i)
    new_leaf <- n + 1L
    new_node <- 2L * n + 1L
    # increment node indices by 1 to accommodate new leaf
    edge <- rbind(tree_old$edge, integer(2), integer(2))
    edge[edge > n] <- edge[edge > n] + 1L
    edge[2 * n - 1, ] <- c(new_node, i)
    edge[2 * n, ] <- c(new_node, new_leaf)
    edge[b, 2] <- new_node
    # add x to lengths of edges into leaves
    edge_length <- c(tree_old$edge.length, double(2))
    ind_leaves <- seq_len(n + 1)
    edge_leaves <- which(edge[, 2] %in% ind_leaves)
    edge_length[edge_leaves] <- edge_length[edge_leaves] + x
    # new edges at end of edge and edge.length, ditto new_node in tip.label
    tree_new <- list(
        edge = edge,
        edge.length = edge_length,
        Nnode = tree_old$Nnode + 1L,
        tip.label = c(tree_old$tip.label, paste0("t", new_leaf))
    )
    class(tree_new) <- "phylo"
    return(tree_new)
}

grow_uniform <- function(tree_old, n, b, i, x) {
    # from branch b detach node b[i[2]] and replace by new_node with edges of
    # length x[1] to node b[i[2]] and of length x[2] to new_node
    #
    # .. b[i[1]] __ b[i[2]] ..  -->  .. b[i[1]] __ new_node __x[1]__ b[i[2]] ..
    #                                                      |__x[2]__ new_leaf
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

plot_tree <- function(tree, n) {
    plot(tree, "phylogram", no.margin = FALSE, align.tip.label = TRUE, main = n)
    ape::edgelabels(round(tree$edge.length, 2), cex = 0.5, adj = 1)
    # ape::tiplabels()
    # ape::nodelabels()
    ape::axisPhylo(backward = FALSE)
}

plot_tree_sequence <- function(s, n_seq) {
    pdf(file.path("trees", sprintf("%s.pdf", s)))
    for (n in seq.int(min(n_seq), max(n_seq))) {
        tree <- ape::read.nexus(sprintf("trees/%s-n%s.nex", s, n))
        plot_tree(tree, n)
    }
    dev.off()
}
