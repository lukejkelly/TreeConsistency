## set up constrained analyses
library("readr")
library("dplyr")
library("stringr")

source("src/finitesites-pars.R")

# data
t <- read_delim(
    "src/finitesites.dat",
    delim = " ",
    col_names = FALSE,
    col_types = cols(.default = "i")
)

for (k in k_seq) {
    s_k <- t[, seq_len(k)]
    t_k <- s_k |> group_by_all() |> count()
    write_delim(
        t_k,
        sprintf("data/constrained-%s.dat", k),
        delim = " ",
        col_names = FALSE
    )
}

# configs
config_template <- read_file("src/finitesites-template.cfg")
for (k in k_seq) {
    config_k <- str_replace(config_template, "XYZ", as.character(k))
    write_file(
        config_k,
        sprintf("configs/constrained-%s.cfg", k)
    )
}

# run file
run_file <- "run/constrained.sh"
write_file("#!/bin/bash\n\n", run_file)
for (k in k_seq) {
    write_file(sprintf("echo \"k = %s\"\n", k), run_file, append = TRUE)
    write_file(
        paste(
            "../tree-zig-zag/Metropolis/Finite_sites/simulate",
            sprintf("configs/constrained-%s.cfg", k),
            ">",
            sprintf("out/constrained-%i.txt\n", k)
        ),
        run_file,
        append = TRUE
    )
}
