## split one large data set of length 2^n into ones of length 2^0, 2^1, etc

data_name <- \(f, s) sprintf("./%s/finitesites-%s.dat", f, s)
config_name <- \(f, s) sprintf("./%s/finitesites-%s.cfg", f, s)

t <- readr::read_delim(
    data_name("Setup", "master"),
    delim = " ",
    col_names = FALSE,
    col_types = readr::cols(.default = "i")
)

n <- nrow(t)
k_max <- ncol(t) - 1
k_seq <- 2^seq.int(1, log2(k_max))

readr::write_lines(n, "Setup/finitesites-n.txt")
readr::write_lines(k_seq, "Setup/finitesites-k.txt")

# write data
for (k in k_seq) {
    s_k <- t[, seq_len(k)]
    t_k <- s_k |> dplyr::group_by_all() |> dplyr::count()
    readr::write_delim(
        t_k,
        data_name("Data", k),
        delim = " ",
        col_names = FALSE
    )
}

# write configs
cfg <- readr::read_file(config_name("Setup", "template"))
for (k in k_seq) {
    cfg_k <- stringr::str_replace(cfg, "XYZ", as.character(k))
    readr::write_file(
        cfg_k,
        config_name("Configs", k)
    )
}

# write run
run_file <- "Setup/finitesites-run.sh"
readr::write_file("#!/bin/bash\n\n", run_file)
for (k in k_seq) {
    readr::write_file(
        paste(
            "../Tree-Zig-Zag/Metropolis/Finite_sites/simulate",
            config_name("Configs", k),
            ">",
            sprintf("./Results/finitesites-%i.txt\n", k)
        ),
        run_file,
        append = TRUE
    )
}
