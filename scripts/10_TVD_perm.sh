#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J TVD_perm
#SBATCH -o TVD_perm_%A_%a.out
#SBATCH -e TVD_perm_%A_%a.err
#SBATCH -p long
#SBATCH -c 2
#SBATCH -a 1-466

source directories.config
source ~/.bashrc

dir=/well/ckb/users/aey472/projects/ckb_popgen/programs/TVD_perm
batch=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' TVD_batch_file_II.txt)

Rscript ${dir}/main.R ${batch}
