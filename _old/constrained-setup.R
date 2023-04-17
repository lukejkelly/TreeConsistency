## set up constrained analyses

library("readr")
library("dplyr")
library("stringr")

d <- read_delim(
    "finitesites-proc.dat",
    delim = " ",
    col_names = FALSE,
    col_types = cols(.default = "i")
)

N <- nrow(d)
K <- ncol(d)
n_seq <- 2^seq_len(log2(N))
k_seq <- 2^seq_len(log2(K))

# data files
for (n in n_seq) {
    for (k in k_seq) {
        d_nk <- d |>
            slice(seq_len(n)) |>
            select(seq_len(k)) |>
            bind_cols(n = 1)
        readr::write_delim(
            d_nk,
            file.path("data", sprintf("constrained-n%s-k%s.dat", n, k)),
            delim = " ",
            col_names = FALSE
        )
    }
}

# config files
config_template <- read_file(file.path("src", "constrained-template.cfg"))
for (n in n_seq) {
    for (k in k_seq) {
        config_nk <- str_replace(
            config_template,
            "XYZ",
            sprintf("n%s-k%s", n, k)
        )
        write_file(
            config_nk,
            file.path("configs", sprintf("constrained-n%s-k%s.cfg", n, k))
        )
    }
}

# run file
run_file <- file.path("run", "constrained.sh")
write_file("#!/bin/bash\n\n", run_file)
for (n in n_seq) {
    for (k in k_seq) {
        write_file(
            sprintf("echo \"n = %s, k = %s\"\n", n, k),
            run_file,
            append = TRUE
        )
        write_file(
            paste(
                file.path(
                    "..",
                    "tree-zig-zag",
                    "Metropolis",
                    "Finite_sites",
                    "simulate"
                ),
                file.path("configs", sprintf("constrained-n%s-k%s.cfg", n, k)),
                ">",
                file.path("out", sprintf("constrained-n%s-k%s.txt\n", n, k))
            ),
            run_file,
            append = TRUE
        )
    }
}
