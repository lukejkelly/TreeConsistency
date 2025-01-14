# Simulate trees

We use the same notation as the paper. Let $ (T_0, \mathbf{x}_0) $ be an infinite-leaf tree with topology $ T_0 $ and branch lengths determined by $ \mathbf{x}_0 $, and denote $ (T_0, \mathbf{x}_0) $ its restriction to the first $ n $ leaves.

The code in this directory simulates a sequence $ (T_0, \mathbf{x}_0) \vert_n $ of trees for a range of $ n $ according to the following distributions:
- Rooted ultrametric trees distributed according to Kingman's coalescent, so $ (T_0, \mathbf{x}_0) \vert_n \sim \Pi^{K, n} $ for each $ n $.
- Unrooted trees distributed uniformly across $ n $-leaf topologies with independent exponentially distributed branch lengths with mean $ 1 $, so $ (T_0, \mathbf{x}_0) \vert_n \sim \Pi^{U, n} $ for each $ n $.

The algorithms to generate the sequences from an initial tree are described mathematically in Section 4 of the paper, we now describe the corresponding scripts and functions in this directory.

## Kingman's coalescent

In the `generate-kingman.R` script, the starting $ n $-leaf tree is drawn from $ \Pi^{K, n} $ via `ape::rcoal()` then the following sequence of operations is repeated until a tree is formed with the desired maximum number of leaves:

- Sample a leaf index $ i \sim \mathrm{Unif}(1, \dotsc, n) $.
- Sample a holding time $ x \sim \mathrm{Exp}(\binom{n + 1}{2}) $.
- Use `grow_kingman()` in `R/grow-kingman.R` to form a new tree with $ n + 1 $ leaves through a speciation event at leaf $ i $ and extending the branches into leaves by $ x $ units.
- Increment $ n \leftarrow n + 1 $.

The below diagram illustrates the operation performed by `grow_kingman()`, where `[]` denotes a branch length, `()` a node and `..` the rest of the tree.
```
..___[l1]___ (1)           ..__________[l1 + x]___________ (1)
..___[l2]___ (2)           ..__________[l2 + x]___________ (2)
..                         ..
..___[li]___ (i)    -->    ..___[li]___(new_node)___[x]___ (i)
..                         ..                   |___[x]___ (new_leaf)
..                         ..
..___[ln]___ (n)           ..__________[ln + x]___________ (n)
```
If the input tree is a draw from $ \Pi^{K, n} $ and the other inputs to `grow_kingman()` are sampled as above, then the output tree is a draw from $ \Pi^{K, n + 1} $.

## Uniform distribution on topologies

In the `generate-uniform.R` script, the starting $ n $-leaf tree is drawn from $ \Pi^{U, n} $ via `ape::rtree()` then the following sequence of operations is repeated until a tree is formed with the desired maximum number of leaves:

- Sample a branch index $ b \sim \mathrm{Unif}(1, \dotsc, 2n - 3) $.
- Sample a permutation $ (i_1, i_2) $ of the nodes connected by $ b $.
- Sample independent branch lengths $ x_1, x_2 \sim \mathrm{Exp}(1) $.
- Use `grow_uniform()` in `R/grow-uniform.R` to form a new tree with $ n + 1 $ leaves by extending branch $ b $ by $ x_1 $ units then attaching a branch of length $ x_2 $ to $ b $ at $ x_1 $ units from $ i_2 $.
- Increment $ n \leftarrow n + 1 $.

The below diagram illustrates the operation performed by `grow_uniform()`, where `[]` denotes a branch length, `()` a node and `..` the rest of the tree.
```
..(i1)__[lb]__(i2)..    -->    ..(i1)__[lb]__(new_node)__[x1]__(i2)..
                                                      |__[x2]__(new_leaf)
```
If the input tree is a draw from $ \Pi^{U, n} $ and the other inputs to `grow_uniform()` are sampled as above, then the output tree is a draw from $ \Pi^{U, n + 1} $.
