# add a leaf edge to an unrooted tree with n tips by detaching node b[i[2]] and
# replacing it by new_node with edges of length x[1] to node b[i[2]] and of
# length x[2] to new_leaf
#
#   ..(b[i[1]])__(b[i[2]])..  -->  ..(b[i[1]])__(new_node)__x[1]__(b[i[2]])..
#                                                        |__x[2]__(new_leaf)
#
# if the input tree is drawn from a distribution uniform over unrooted
# topologies with n tips and independent exponential branch lengths, b is
# chosen uniformly at random from the branch indices, i is a random permutation
# of the nodes connected by b and x is a pair of indpendent exponential random
# variables with rate 1, then the output is a tree uniform over unrooted
# topologies with n + 1 leaves and independent exponential branch lengths
# this is the case in grow-uniform.R

grow_uniform <- function(tree_old, n, b, i, x) {
    # detach node b[i[2]] and replace by new_node with edges of length x[1] to
    # node b[i[2]] and of length x[2] to new_leaf
    # tree_old: unrooted class "phylo" tree object
    # n: number of tips in tree_old
    # b: index of branch to modify
    # i: vector indexing parent and child nodes in b
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
