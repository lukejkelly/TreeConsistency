grow_uniform <- function(tree_old, n, b, i, x) {
    # detach node b[i[2]] and replace by new_node with edges of length x[1] to
    # node b[i[2]] and of length x[2] to new_leaf
    # tree_old: unrooted class "phylo" tree object
    # n: number of tips in tree_old
    # b: index of branch to modify
    # i: vector to permute nodes connected by b
    # x: lengths of new edges

    # indices of new nodes
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
