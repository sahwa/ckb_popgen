#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J full_finestructure_external_only
#SBATCH -o full_finestructure_external_only_%j.out
#SBATCH -e full_finestructure_external_only_%j.err
#SBATCH -p short
#SBATCH -c 2
#SBATCH --array 1

chr=${SLURM_ARRAY_TASK_ID}

## dirs 

ckb_external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external
painting_output=/well/ckb/users/aey472/projects/ckb_popgen/data/painting_output
programs=/well/ckb/users/aey472/projects/ckb_popgen/programs
fs_output=/well/ckb/users/aey472/projects/ckb_popgen/data/finestructure_output
sf_dir=/well/ckb/users/aey472/projects/ckb_popgen/programs/sourcefindV2


${sf_dir}/sourcefindV2.R \


