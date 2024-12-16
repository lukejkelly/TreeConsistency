# create slurm array job submission script

# setting up
source("pars.R")

# template with parts to be replaced
script_template <- stringr::str_c(
    "#!/bin/bash -l\n\n",

    "#SBATCH --mail-user=lkelly@ucc.ie\n",
    "#SBATCH --mail-type=END\n\n",

    "#SBATCH -A p200482\n",
    "#SBATCH -p cpu\n",
    "#SBATCH -q default\n\n",

    "#SBATCH -N 1\n",
    "#SBATCH -n 1\n",
    "#SBATCH -c 1\n",
    "#SBATCH --ntasks-per-node=1\n\n",

    "#SBATCH --time=24:0:0\n",
    "#SBATCH --array=_R_MIN_-_R_MAX_%100\n",
    "#SBATCH -o out/slurm-%A_%a.log\n\n",

    "ml Boost\n",
    "cd /project/home/p200482/TreeConsistency\n",
    "RB=/project/home/p200482/revbayes-1.2.4/projects/cmake/rb\n\n",

    "for S in _S_SEQ_; do\n",
    stringr::str_dup(" ", 4), "for N in _N_SEQ_; do\n",
    stringr::str_dup(" ", 8), "for M in _M_SEQ_; do\n",
    stringr::str_dup(" ", 12), "for K in _K_SEQ_; do\n",
    stringr::str_dup(" ", 16), "MODEL_FILE=$( \\\n",
    stringr::str_dup(" ", 20), "printf \"%s-n%s-m%s-k%s-r%s.Rev\" \"$S\" \"$N\" \"$M\" \"$K\" \"$SLURM_ARRAY_TASK_ID\" \\\n",
    stringr::str_dup(" ", 16), ")\n",
    stringr::str_dup(" ", 16), "$RB --file run/${MODEL_FILE}\n",
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
    file.path("slurm", "job.sh")
)
