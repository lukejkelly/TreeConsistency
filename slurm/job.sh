#!/bin/bash -l

#SBATCH --mail-user=lkelly@ucc.ie
#SBATCH --mail-type=END

#SBATCH -A p200482
#SBATCH -p cpu
#SBATCH -q default

#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --ntasks-per-node=1

#SBATCH --time=24:0:0
#SBATCH --array=1-100%100
#SBATCH -o out/slurm-%A_%a.log

ml Boost
cd /project/home/p200482/TreeConsistency
RB=/project/home/p200482/revbayes-1.2.4/projects/cmake/rb

for S in kingman uniform; do
    for N in 4 7 10 13 16; do
        for M in 0.0125 0.025 0.05 0.1; do
            for K in 1 10 100 1000 10000 1e+05; do
                MODEL_FILE=$( \
                    printf "%s-n%s-m%s-k%s-r%s.Rev" "$S" "$N" "$M" "$K" "$SLURM_ARRAY_TASK_ID" \
                )
                $RB --file run/${MODEL_FILE}
            done
        done
    done
done
