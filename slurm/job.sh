#!/bin/bash -l

#SBATCH --mail-user=lkelly@ucc.ie
#SBATCH --mail-type=END

#SBATCH -A p200482
#SBATCH -p cpu
#SBATCH -q default

#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1

#SBATCH -o out/slurm-%A_%a.log

# setting up
cd /project/home/p200482/TreeConsistency
MODEL_FILE=$( \
    printf "%s-n%s-m%s-k%s-r%s.Rev" "$S" "$N" "$M" "$K" "$SLURM_ARRAY_TASK_ID" \
)

# run job
ml Boost
/project/home/p200482/revbayes-1.2.4/projects/cmake/rb --file run/${MODEL_FILE}
