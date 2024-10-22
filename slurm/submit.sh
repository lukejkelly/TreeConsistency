#!/bin/bash

mkdir out

for S in kingman uniform; do
    for N in 4 5 6 7 8; do
        for M in 0.25 0.5 1 2; do
            for K in 1 10 100 1000; do
                sbatch \
                    --job-name=${S}-${N}-${M}-${K} \
                    --export=ALL,S=${S},N=${N},M=${M},K=${K} \
                    --array=1-50%10 \
                    --time=${N}:0:0\
                    slurm/job.sh
            done
        done
    done
done
