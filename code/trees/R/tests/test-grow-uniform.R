# unit test function which adds a leaf to a randomly chosen edge and extends it
test_that(
    "sequentially growing unrooted trees uniform across topologies",
    {
        for (n in seq.int(4, 6)) {
            t1 <- ape::rtree(n, rooted = FALSE, br = \(n) rep(1, n))
            expect_equal(length(t1$edge.length), 2 * n - 3)
            for (b in seq_len(2 * n - 3)) {
                for (i in list(c(1, 2), c(2, 1))) {
                    x <- rexp(2)
                    t2 <- grow_uniform(t1, n, b, i, x)
                    # no warnings or errors in tree structure
                    c2 <- capture.output(ape::checkValidPhylo(t2))
                    for (k in seq_along(c2)) {
                        expect_equal(stringr::str_count(c2[[k]], "MODERATE"), 0)
                        expect_equal(stringr::str_count(c2[[k]], "FATAL"), 0)
                    }

                    if (t1$edge[b, i[2]])
                    e2_1 <- sapply(
                        seq_along(t2$edge),
                        \(j) which(t2$edge[, i] == t1$edge[b])
                    )
                    # new leaf and node indices
                    i_new_leaf <- n + 1
                    e_new_leaf <- which(t2$edge[, 2] == i_new_leaf)
                    expect_equal(t1$tip.label, t2$tip.label[-i_new_leaf])
                    expect_equal(
                        t2$tip.label[i_new_leaf],
                        paste0("t", i_new_leaf)
                    )
                    i_new_node <- 2 * n
                    e_new_node <- which(t2$edge[, 1] == i_new_node)
                    if (i[1] == 1) {
                        expect_equal(e_new_node, c(2 * n - 2, 2 * n - 1))
                    } else {
                        expect_equal(e_new_node, c(b, 2 * n - 1))
                    }
                    if (t1$edge[b, 2] <= n) {
                        expect_equal(
                            t2$edge[e_new_node, 2],
                            c(t1$edge[b, 2], i_new_leaf)
                        )
                    } else {
                        expect_equal(
                            t2$edge[e_new_node, 2],
                            c(t1$edge[b, 2] + 1, i_new_leaf)
                        )
                    }
                    # edge lengths
                    expect_equal(t1$edge.length[b], t2$edge.length[b])
                    expect_equal(x, t2$edge.length[c(2 * n - 2, 2 * n - 1)])
                    expect_equal(
                        sum(t1$edge.length) + sum(x),
                        sum(t2$edge.length)
                    )
                }
            }
        }
    }
)
