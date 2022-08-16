library("readr")
library("dplyr")
library("stringr")

source("./Setup/finitesites-pars.R")

# read full data set
data_name <- \(f, s) sprintf("./%s/finitesites-%s.dat", f, s)
t <- read_delim(
    data_name("Setup", "master"),
    delim = " ",
    col_names = FALSE,
    col_types = cols(.default = "i")
)

# write data subsets
for (k in k_seq) {
    s_k <- t[, seq_len(k)]
    t_k <- s_k |> group_by_all() |> count()
    write_delim(t_k, data_name("Data", k), delim = " ", col_names = FALSE)
}

# write configs
config_name <- \(f, s) sprintf("./%s/finitesites-%s.cfg", f, s)
config <- read_file(config_name("Setup", "template"))
for (k in k_seq) {
    config_k <- str_replace(config, "XYZ", as.character(k))
    write_file(
        config_k,
        config_name("Configs", k)
    )
}

# write run file
run_name <- "Setup/finitesites-run.sh"
write_file("#!/bin/bash\n\n", run_name)
sim <-
for (k in k_seq) {
    write_file(sprintf("echo \"k = %s\"\n", k), run_name, append = TRUE)
    write_file(
        paste(
            "../Tree-Zig-Zag/Metropolis/Finite_sites/simulate",
            config_name("Configs", k),
            ">",
            sprintf("./Results/finitesites-%i.txt\n", k)
        ),
        run_name,
        append = TRUE
    )
}
