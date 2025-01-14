
grow_kingman <- function(tree_old, n, i, x) {
    # add a sibling to leaf i in tree_old then extend external edges by x units
    # tree_old: rooted class "phylo" tree object
    # n: number of tips in tree_old
    # i: index of leaf to split
    # x: amount by which to extend external edges

    # indices of branch to split and new nodes
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
