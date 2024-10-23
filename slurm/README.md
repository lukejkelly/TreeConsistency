# Running jobs in parallel via slurm

Having set the run parameters in `pars.R`, create the slurm job submission script by executing
```bash
R -f slurm/make-submit.R
```
from the top level directory. This will create `slurm/submit.sh` which submits each experiment (tree prior, number of leaves, mutation rate, number of alleles) as a job array over the replication indices. The default number of replications to run in parallel is 10. Executing
```bash
bash slurm/submit.sh
```
will loop through the experiments and launch jobs by passing arguments to the `slurm/job.sh` script.

---

# MeluXina

_Various notes for running jobs on the MeluXina supercomputer._

The `slurm/get-rb.sh` script downloads the corresponding release of RevBayes, untars the directory and builds the `rb` executable.

## Getting set up
https://docs.lxp.lu/first-steps/handling_jobs/#slurm-project-accounts

## Show projects (mine is p200482)
sacctmgr show user $USER withassoc format=user,account,defaultaccount

## Additional details about your user and the SLURM accounts
sacctmgr show user $USER withassoc
sacctmgr show account withassoc

## Quick start
https://docs.lxp.lu/first-steps/quick_start/

## Launch interactive job
salloc -A p200482 --res cpudev -q dev -N 1 -n 1 -c 1 -t 2:0:0

## Compute and memory quotas
myquota

## Sending files
rsync -ahHSv TreeConsistency meluxina:/project/home/p200482

## Modules required to run R v4.4.1
ml env/staging/2024.1
ml ICU
ml R/4.4.1-gfbf-2024a
