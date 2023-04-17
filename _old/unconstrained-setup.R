## set up unconstrained analyses

library("readr")
library("dplyr")
library("stringr")
library("ape")
library("purrr")

# data
d <- read_delim(
    "finitesites.dat",
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
            transpose()
        temp_file <- tempfile()
        write.nexus.data(d_nk, temp_file, format = "standard")
        e_nk <- temp_file |>
            read_file() |>
            str_remove("symbols=\"0123456789\"")
        write_file(
            e_nk,
            file.path("data", sprintf("unconstrained-n%s-k%s.nex", n, k))
        )
    }
}

# configs
config_template <- read_file(file.path("src", "unconstrained-template.txt"))
for (n in n_seq) {
    for (k in k_seq) {
        config_nk <- str_replace_all(
            config_template,
            "XYZ",
            sprintf("n%s-k%s", n, k)
        )
        write_file(
            config_nk,
            file.path("configs", sprintf("unconstrained-n%s-k%s.txt", n, k))
        )
    }
}

# run file
run_file <- file.path("run", "unconstrained.sh")
write_file("#!/bin/bash\n\n", run_file)
fmt <- paste(
    "mb",
    "<",
    file.path("configs", "unconstrained-n%1$s-k%2$s.txt"),
    ">",
    file.path("out", "unconstrained-n%1$s-k%2$s.log\n")
)
for (n in n_seq) {
    for (k in k_seq) {
        write_file(
            sprintf("echo \"n = %s, k = %s\"\n", n, k),
            run_file,
            append = TRUE
        )
        write_file(
            sprintf(fmt, n, k),
            run_file,
            append = TRUE
        )
    }
}
