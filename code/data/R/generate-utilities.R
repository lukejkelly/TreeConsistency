# helper functions for simulating trees and data

write_tree <- function(tree, s, n) {
    # write tree in nexus format to t0 folder of trees used to generate data
    # tree: class "phylo" tree object
    # s: type of tree is either "kingman" if coalescent or "uniform" if unrooted
    # n: integer number of leaves of tree
    ape::write.nexus(
        tree,
        file = file.path("t0", sprintf("%s-n%s.nex", s, n)),
        translate = FALSE
    )
    return(NULL)
}

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
    # simulate alleles at max(k_seq) sites on a sequence of trees for a grid of
    # mutation rates and replication indices
    # s: type of tree is either "kingman" if coalescent or "uniform" if unrooted
    # n_seq: sequence of numbers of leaves for which trees have been generated
    # m_seq: sequence of mutation rates for JC69 model used to generate data
    # k_seq: sequence of numbers of sites, in practice alleles are generated at
    #   max(k_seq) sites and the other data sets are increasing subsets
    # r_seq: sequence of replication indices
    k_max <- max(k_seq)
    pb <- progress::progress_bar$new(total = length(n_seq) * length(m_seq))
    for (n in n_seq) {
        tree <- file.path("t0", sprintf("%s-n%s.nex", s, n)) |>
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

grow_kingman <- function(tree_old, n, i, x) {
    # add sibling of leaf i in tree_old and extend edges into leaves by x units
    #   ..___[l1]___ (1)       ..__________[l1 + x]___________ (1)
    #   ..___[l2]___ (2)       ..__________[l2 + x]___________ (2)
    #   ..                     ..
    #   ..___[li]___ (i)  -->  ..___[li]___(new_node)___[x]___ (i)
    #   ..                     ..                   |___[x]___ (new_leaf)
    #   ..                     ..
    #   ..___[ln]___ (n)       ..__________[ln + x]___________ (n)
    # in generate-kingman tree_old is a coalescent tree on n leaves, i is drawn
    # uniformly at random from the tip indices and x from the exponential
    # distribution with rate choose(n + 1, 2) so tree_new is a coalescent tree
    # on n + 1 tips
    # tree_old: rooted class "phylo" tree object
    # n: number of tips in tree_old
    # i: index of leaf to split
    # x: amount by which to extend external edges
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
    #   ..(b[i[1]])__(b[i[2]])..
    #     -->  ..(b[i[1]])__(new_node)__x[1]__(b[i[2]])..
    #                                |__x[2]__(new_leaf)
    # in generate-uniform tree_old is drawn from a distribution uniform over
    # unrooted topologies with n tips and independent exponential branch
    # lengths, and b, i and x are drawn such that tree_new is a sample from a
    # distribution uniform over unrooted topologies with n + 1 leaves and
    # independent exponential branch lengths
    # tree_old: unrooted class "phylo" tree object
    # n: number of tips in tree_old
    # b: index of branch to modify
    # i: vector choosing parent and child nodes in b
    # x: length of edge into new leaf
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

plot_tree <- function(tree) {
    # plot tree according to type
    # tree: rooted or unrooted class "phylo" tree object
    n <- ape::Ntip(tree)
    if (ape::is.rooted(tree)) {
        ape::plot.phylo(tree, align.tip.label = TRUE, main = n)
        # ape::edgelabels(round(tree$edge.length, 2), cex = 0.5, adj = 1)
        # ape::tiplabels()
        # ape::nodelabels()
        ape::axisPhylo(backward = FALSE)
    } else {
        ape::plot.phylo(tree, "unrooted", main = n)
        # ape::edgelabels(round(tree$edge.length, 2), cex = 0.5)
        # ape::tiplabels()
        # ape::nodelabels()
        ape::add.scale.bar(length = 1, lcol = "blue", col = "blue")
    }
    return(NULL)
}

plot_tree_sequence <- function(s, n_seq) {
    # create pdf displaying sequence of simulated trees
    # s: type of tree is either "kingman" if coalescent or "uniform" if unrooted
    # n_seq: number of leaves of generated trees
    pdf(file.path("figs", sprintf("%s-t0.pdf", s)))
    for (n in seq.int(min(n_seq), max(n_seq))) {
        tree <- file.path("t0", sprintf("%s-n%s.nex", s, n)) |>
            ape::read.nexus()
        plot_tree(tree)
    }
    dev.off()
}
