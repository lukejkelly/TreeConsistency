#!/bin/bash

mkdir out

for S in kingman uniform; do
    for N in 4 7 10; do
        for M in 0.5 0.75 1 1.25 1.5; do
            for K in 1 10 100 1000 10000; do
                sbatch \
                    --job-name=${S}-${N}-${M}-${K} \
                    --export=ALL,S=${S},N=${N},M=${M},K=${K} \
                    --array=1-100%10 \
                    --time=${N}:0:0\
                    slurm/job.sh
            done
        done
    done
done
