# helper functions for simulating trees

write_tree <- function(tree, s, n) {
    # write tree in nexus format to trees directory
    # tree: class "phylo" tree object
    # s: type of tree is either "kingman" if coalescent or "uniform" if unrooted
    # n: integer number of leaves of tree
    ape::write.nexus(
        tree,
        file = file.path("trees", sprintf("%s-n%s.nex", s, n)),
        translate = FALSE
    )
    return(NULL)
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
        tree <- file.path("trees", sprintf("%s-n%s.nex", s, n)) |>
            ape::read.nexus()
        plot_tree(tree)
    }
    dev.off()
}
