# R script to generate slurm array job submission script

# setting up
source("../pars.R")

# template with parts to be replaced
script_template <- stringr::str_c(
    "#!/bin/bash\n\n",
    "for S in _S_SEQ_; do\n",
    stringr::str_dup(" ", 4), "for N in _N_SEQ_; do\n",
    stringr::str_dup(" ", 8), "for M in _M_SEQ_; do\n",
    stringr::str_dup(" ", 12), "for K in _K_SEQ_; do\n",
    stringr::str_dup(" ", 16), "sbatch \\\n",
    stringr::str_dup(" ", 20), "--job-name=${S}-${N}-${M}-${K} \\\n",
    stringr::str_dup(" ", 20), "--export=ALL,S=${S},N=${N},M=${M},K=${K} \\\n",
    stringr::str_dup(" ", 20), "--array _R_MIN_:_R_MAX_%10 \\\n",
    stringr::str_dup(" ", 20), "--time ${N}:0:0\\\n",
    stringr::str_dup(" ", 20), "slurm/job.sh\n",
    stringr::str_dup(" ", 12), "done\n",
    stringr::str_dup(" ", 8), "done\n",
    stringr::str_dup(" ", 4), "done\n",
    "done", "\n"
)

# substitute template entries with corresponding parameter sequences
script_text <-
    script_template |>
    stringr::str_replace(
        "_S_SEQ_",
        stringr::str_flatten(s_seq, collapse = " ")
    ) |>
    stringr::str_replace(
        "_N_SEQ_",
        stringr::str_flatten(n_seq, collapse = " ")
    ) |>
    stringr::str_replace(
        "_M_SEQ_",
        stringr::str_flatten(m_seq, collapse = " ")
    ) |>
    stringr::str_replace(
        "_K_SEQ_",
        stringr::str_flatten(k_seq, collapse = " ")
    ) |>
    stringr::str_replace(
        "_R_MIN_",
        stringr::str_c(min(r_seq))
    ) |>
    stringr::str_replace(
        "_R_MAX_",
        stringr::str_c(max(r_seq))
    )

# write file in same location
readr::write_file(
    script_text,
    # file.path("run", sprintf("%s-n%s-m%s-k%s-r%s.Rev", s, n, m, k, r))
    "submit.sh"
)
