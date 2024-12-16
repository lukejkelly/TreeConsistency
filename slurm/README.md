# Running jobs in parallel on a cluster

To run the experiments on the MeluXina server with the Slurm job scheduler, complete the following steps in a bash terminal at the top level of the repository.

1) Load the necessary modules to run R via `ml env/staging/2024.1; ml R/4.4.1-gfbf-2024a; ml ICU`, then start R from the top level of the directory and update `renv` as described [here](../README.md). Quit R and return to the command prompt.
2) Having completed step (1), execute `sbatch slurm/init.sh` to generate trees, data and RevBayes scripts.
3) Execute `sbatch slurm/get-rb.sh` to download and build RevBayes.
4) Having completed steps (3) and (4), execute `mkdir out; sbatch slurm/job.sh` to run the MCMC analyses in parallel as a grid array.

If you vary the run parameters in `pars.R`, you can update the job submission script by executing `R -f slurm/make-job.R`.

---

# MeluXina

Various notes for running jobs on the MeluXina supercomputer.

## Getting set up
https://docs.lxp.lu/first-steps/handling_jobs/#slurm-project-accounts

## Show projects (mine is p200482)
`sacctmgr show user $USER withassoc format=user,account,defaultaccount`

## Additional details about your user and the SLURM accounts
```bash
sacctmgr show user $USER withassoc
sacctmgr show account withassoc
```

## Quick start
https://docs.lxp.lu/first-steps/quick_start/

## Launch interactive job
`salloc -A p200482 --res cpudev -q dev -N 1 -n 1 -c 1 -t 2:0:0`

## Compute and memory quotas
`myquota`

## Sending files
`rsync -ahHSv TreeConsistency meluxina:/project/home/p200482`

## Modules required to run R v4.4.1
```bash
ml env/staging/2024.1
ml R/4.4.1-gfbf-2024a
ml ICU
```
