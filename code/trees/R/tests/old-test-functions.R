# tests which used at various stages of development but are no longer active

# test_that(
#     "tip labels to tip.label indices to edge indices",
#     {
#         n <- 7
#         r_seq <- c(FALSE, TRUE)
#         for (r in r_seq) {
#             tree <- ape::rtree(n, rooted = r)
#             labs <- sample(tree$tip.label, ceiling(n / 2))
#
#             inds_labs_obs <- get_inds_labs(labs, tree)
#             inds_labs_exp <- integer(length(labs))
#             for (j in seq_along(inds_labs_exp)) {
#                 inds_labs_exp[j] = which(tree$tip.label == labs[j])
#             }
#             expect_equal(inds_labs_obs, inds_labs_exp)
#
#             inds_edge_obs <- get_inds_edge(inds_labs_obs, tree)
#             inds_edge_exp <- integer(length(labs))
#             for (j in seq_along(inds_edge_exp)) {
#                 inds_edge_exp[j] <- which(tree$edge[, 2] == inds_labs_obs[j])
#             }
#             expect_equal(inds_edge_obs, inds_edge_exp)
#         }
#     }
# )
#
# test_that(
#     "extend branches into selected leaves",
#     {
#         n <- 5
#         r_seq <- c(FALSE, TRUE)
#         for (r in r_seq) {
#             for (s in seq_len(n)) {
#                 tree_before <- ape::rtree(n, rooted = r)
#                 x <- rexp(1)
#                 labs <- tree_before$tip.label[seq_len(s)]
#
#                 inds_labs <- get_inds_labs(labs, tree_before)
#                 expect_equal(inds_labs, seq_len(s))
#
#                 tree_after <- extend_leaves(tree_before, labs, x)
#
#                 expect_equal(tree_before$edge, tree_after$edge)
#                 expect_equal(tree_before$tip.label, tree_after$tip.label)
#                 expect_equal(tree_before$Nnode, tree_after$Nnode)
#
#                 inds_edge_lgl <- tree_before$edge[, 2] %in% seq_len(s)
#                 inds_edge <- which(inds_edge_lgl)
#                 expect_equal(inds_edge, get_inds_edge(inds_labs, tree_before))
#                 expect_equal(
#                     tree_before$edge.length[inds_edge_lgl] + x,
#                     tree_after$edge.length[inds_edge_lgl]
#                 )
#                 expect_equal(
#                     tree_before$edge.length[!inds_edge_lgl],
#                     tree_after$edge.length[!inds_edge_lgl]
#                 )
#             }
#         }
#     }
# )
#
# test_that(
#     "check kingman",
#     {
#         wd <- getwd()
#         setwd(file.path("..", ".."))
#         if (any(dir.exists(c("trees", "data", "pars")))) {
#             skip("skipping test to avoid overwriting existing files")
#         } else {
#             purrr::walk(c("trees", "data", "pars"), dir.create)
#         }
#         commandArgs <- function(...) c(5, 3, 4)
#         source(file.path("R", "generate-kingman.R"), TRUE)
#
#         expect_equal(args, c(N, J, mu))
#         expect_equal(ape::Ntip(tree), N)
#         j1 <- which(tree$tip.label == i1)
#         j2 <- which(tree$tip.label == i2)
#         k1 <- which(tree$edge[, 2] == j1)
#         k2 <- which(tree$edge[, 2] == j2)
#         expect_equal(tree$edge[k1, 1], tree$edge[k2, 1])
#         expect_equal(tree$edge.length[k1], x)
#         expect_equal(tree$edge.length[k1], tree$edge.length[k2])
#         purrr::walk(
#             tree$edge.length[tree$edge[, 2] %in% setdiff(seq_len(N), c(j1, j2))],
#             \(y) expect_lt(x, y)
#         )
#
#         unlink(c("trees", "data", "pars"), TRUE)
#         setwd(wd)
#     }
# )
#
# test_that(
#     "check uniform",
#     {
#         wd <- getwd()
#         setwd(file.path("..", ".."))
#         if (any(dir.exists(c("trees", "data", "pars")))) {
#             skip("skipping test to avoid overwriting existing files")
#         } else {
#             purrr::walk(c("trees", "data", "pars"), dir.create)
#         }
#         commandArgs <- function(...) c(5, 3, 4)
#         source(file.path("R", "generate-uniform.R"), TRUE)
#
#         expect_equal(args, c(N, J, mu))
#         expect_equal(ape::Ntip(tree), N)
#         j1 <- which(tree$tip.label == i1)
#         j2 <- which(tree$tip.label == i2)
#         k1 <- which(tree$edge[, 2] == j1)
#         k2 <- which(tree$edge[, 2] == j2)
#         expect_equal(tree$edge[k1, 1], tree$edge[k2, 1])
#         expect_equal(tree$edge.length[k1], x)
#         expect_equal(tree$edge.length[k1], tree$edge.length[k2])
#
#         unlink(c("trees", "data", "pars"), TRUE)
#         setwd(wd)
#     }
# )
#
# test_that(
#     "duplicating alleles after a branching event",
#     {
#         n <- 10
#         tree <- ape::rtree(n)
#         K <- 20
#         mu <- 2
#         alleles_before <- as.data.frame(
#             phangorn::simSeq(
#                 tree,
#                 l = K,
#                 type = "USER",
#                 levels = c("0", "1"),
#                 rate = mu
#             )
#         )
#         i0 <- sample.int(n, 1)
#         i1 <- tree$tip.label[i0]
#         i2 <- paste0("t", n + 1)
#         alleles_after <- duplicate_alleles(alleles_before, i1, i2)
#         expect_equal(length(alleles_after), n + 1)
#         expect_equal(alleles_before, alleles_after[seq_len(n)])
#         expect_equal(alleles_before[[i1]], alleles_after[[i2]])
#         expect_equal(c(names(alleles_before), i2), names(alleles_after))
#     }
# )
#
# test_that(
#     "mutating alleles",
#     {
#         levels <- c("0", "1")
#
#         K1 <- 10
#         a1 <- data.frame(t1 = rep(levels[1], K1), t2 = rep(levels[2], K1))
#         expect_equal(a1, mutate_alleles(a1, "t1", 0))
#         expect_equal(a1, mutate_alleles(a1, "t2", 0))
#         expect_equal(a1, mutate_alleles(a1, c("t1", "t2"), 0))
#
#         for (r in seq_len(10)) {
#             K2 <- 1e6
#             mu <- rexp(1)
#             a2 <- data.frame(
#                 t1 = sample(levels, K2, replace = TRUE),
#                 t2 = sample(levels, K2, replace = TRUE),
#                 t3 = sample(levels, K2, replace = TRUE)
#             )
#             p_exp <- 0.5 * (1 + exp(-2 * mu))
#             q_exp <- 1 - p_exp
#
#             b1 <- mutate_alleles(a2, "t1", mu)
#             y1 <- sum(a2[1] == b1[1])
#             m1 <- p_exp * K2
#             s1 <- sqrt(p_exp * q_exp * K2)
#             t1 <- (y1 - m1) / s1
#             expect_true(abs(t1) <= 4)
#             expect_equal(a2[2:3], b1[2:3])
#
#             b2 <- mutate_alleles(a2, c("t2", "t3"), mu)
#             expect_equal(a2[1], b2[1])
#             y2 <- sum(a2[2:3] == b2[2:3])
#             m2 <- 2 * p_exp * K2
#             s2 <- sqrt(p_exp * q_exp * 2 * K2)
#             t2 <- (y2 - m2) / s2
#             expect_true(abs(t2) <= 4)
#         }
#     }
# )
