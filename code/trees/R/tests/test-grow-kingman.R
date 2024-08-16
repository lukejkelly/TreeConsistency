# unit test function which adds a leaf and extends external edges
test_that(
    "sequentially growing kingman coalescent trees",
    {
        old_grow_kingman <- function(tree_old, n, i, x) {
            # create sibling of leaf i and extend edges into leaves by x units
            tree_new <- TreeTools::AddTip(
                tree_old,
                i,
                paste0("t", n + 1),
                0,
                0,
                0
            )
            ind_leaves <- seq_len(n + 1)
            edge_leaves <- which(tree_new$edge[, 2] %in% ind_leaves)
            tree_new$edge.length[edge_leaves] <- tree_new$edge.length[edge_leaves] + x
            return(tree_new)
        }

        for (n in seq.int(4, 8)) {
            t1 <- ape::rcoal(n)
            e1_l_i <- sapply(seq_len(n), \(i) which(t1$edge[, 2] == i))
            e1_l_l <- t1$edge.length[e1_l_i]
            for (i in seq_len(n)) {
                x <- rexp(1, choose(n + 1, 2))
                t2 <- grow_kingman(t1, n, i, x)
                # no errors in definition
                expect_equal(2 * (n + 1) - 2, nrow(t2$edge))
                expect_equal(nrow(t1$edge) + 2, nrow(t2$edge))
                expect_equal(length(t1$edge.length) + 2, length(t2$edge.length))
                expect_equal(length(t1$tip.label) + 1, length(t2$tip.label))
                expect_equal((n + 1) - 1, t2$Nnode)
                expect_equal(t1$Nnode + 1, t2$Nnode)
                # no errors in tree structure
                c2 <- capture.output(ape::checkValidPhylo(t2))
                for (k in seq_along(c2)) {
                    expect_equal(stringr::str_count(c2[[k]], "MODERATE"), 0)
                    expect_equal(stringr::str_count(c2[[k]], "FATAL"), 0)
                }
                # edge lengths correct
                e2_l_i <- sapply(seq_len(n + 1), \(j) which(t2$edge[, 2] == j))
                e2_l_l <- t2$edge.length[e2_l_i]
                expect_equal(e1_l_l[-i], e2_l_l[-c(i, n + 1)] - x)
                expect_equal(e2_l_l[c(i, n + 1)], rep(x, 2))
                # parent nodes identical
                p <- t2$edge[t2$edge[, 2] %in% c(i, n + 1), 1]
                expect_equal(p[1], p[2])
                # parent branch length
                l1 <- t1$edge.length[t1$edge[, 2] == i]
                l2 <- t2$edge.length[t2$edge[, 2] == p[1]]
                expect_equal(l1, l2)
                # compare to TreeTools implementation
                t3 <- old_grow_kingman(t1, n, i, x)
                expect_true(ape::all.equal.phylo(t2, t3))
            }
        }
    }
)
