#!/bin/bash -l

#SBATCH --mail-user=lkelly@ucc.ie
#SBATCH --mail-type=END

#SBATCH -A p200482
#SBATCH -p cpu
#SBATCH -q dev

#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1

#SBATCH -o get-rb.out
#SBATCH -t 1:30:00

git clone --branch v1.2.4 --depth 1 https://github.com/revbayes/revbayes.git
cd revbayes/projects/cmake
ml Boost GCC CMake
./build.sh
