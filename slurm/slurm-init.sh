#!/bin/bash -l

#SBATCH --mail-user=lkelly@ucc.ie
#SBATCH --mail-type=END

#SBATCH -A p200482
#SBATCH -p cpu
#SBATCH -q default

#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1

#SBATCH -o slurm-init.log

#SBATCH --time=24:0:0

# setting up
ml env/staging/2024.1
ml R/4.4.1-gfbf-2024a
ml ICU

# project directory
cd /project/home/p200482/TreeConsistency

# setup scripts
bash scripts/trees.sh &&
bash scripts/data.sh &&
bash scripts/model.sh

