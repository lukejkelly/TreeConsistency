#!/bin/bash

# path to revbayes executable
RB=/Users/kelly/.bin/rb

# execute revbayes on each run file in parallel over tree type and mutation rate
mkdir -p out log
for S in kingman uniform; do
    for M in 0.0125 0.025 0.05 0.1 0.2; do
        for N in 4 7 10 13 16; do
            for K in 1 10 100 1000 10000 1e+05; do
                for R in {1..100}; do
                    MODEL_FILE=$( \
                        printf "%s-n%s-m%s-k%s-r%s.Rev" "$S" "$N" "$M" "$K" "$R" \
                    )
                    $RB --file run/${MODEL_FILE}
                done
            done
        done &> log/${S}-${M}.log &
        echo "PID ${S}-${M} $!"
    done
done
wait
