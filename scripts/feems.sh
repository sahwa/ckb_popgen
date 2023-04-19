#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J finestructure_external_only
#SBATCH -o finestructure_external_only_%j.out
#SBATCH -e finestructure_external_only_%j.err
#SBATCH -p long
#SBATCH -c 1
#SBATCH --array 1

mamba create -n feems
mamba install -c bioconda feems -c conda-forge
mamba activate feems
