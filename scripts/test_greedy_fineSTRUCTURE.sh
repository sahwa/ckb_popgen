#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J pbwt_representative
#SBATCH -o pbwt_representative_%j.out
#SBATCH -e pbwt_representative_%j.err
#SBATCH -p short
#SBATCH -c 32
#SBATCH --array 1-22

### this is just a test run to see how greedy finestructure deals with different sample sizes ####

### first run the script to identify subsets of representative samples from each RC ####



