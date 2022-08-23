## set up unconstrained analyses
library("readr")
library("dplyr")
library("purrr")
library("stringr")
library("ape")

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
    t_k <- map(seq_len(n), ~ paste0(s_k[., ,]))
    f_k <- sprintf("data/unconstrained-%s.nex", k)
    write.nexus.data(t_k, f_k, format = "standard")
    r_k <- read_file(f_k) |>
        str_remove("symbols=\"0123456789\"")
    write_file(r_k, f_k)
}

# configs
config_template <- read_file("src/unconstrained-template.txt")
for (k in k_seq) {
    config_k <- str_replace_all(config_template, "XYZ", as.character(k))
    write_file(
        config_k,
        sprintf("configs/unconstrained-%s.txt", k)
    )
}

# run file
run_file <- "run/unconstrained.sh"
write_file("#!/bin/bash\n\n", run_file)
fmt <- "mb < configs/unconstrained-%1$i.txt > out/unconstrained-%1$i.log\n"
for (k in k_seq) {
    write_file(sprintf("echo \"k = %s\"\n", k), run_file, append = TRUE)
    write_file(sprintf(fmt, k), run_file, append = TRUE)
}
