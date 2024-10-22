#!/bin/bash -l

#SBATCH --mail-user=lkelly@ucc.ie
#SBATCH --mail-type=END

#SBATCH -A p200482
#SBATCH -p cpu
#SBATCH -q dev

#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1

#SBATCH -o /project/home/p200482/get-rb.out
#SBATCH -t 1:30:00

# change to parent directory of TreeConsistency and RevBayes
cd /project/home/p200482

# download and extract files
wget https://github.com/revbayes/revbayes/archive/refs/tags/v1.2.4.tar.gz
tar -xvz -f v1.2.4.tar.gz

# build
cd revbayes-1.2.4/projects/cmake
ml Boost GCC CMake
./build.sh
