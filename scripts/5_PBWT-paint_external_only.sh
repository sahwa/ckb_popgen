#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J pbwt_representative
#SBATCH -o pbwt_representative_%j.out
#SBATCH -e pbwt_representative_%j.err
#SBATCH -p short
#SBATCH -c 4
#SBATCH --array 1-22

ckb_external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external
painting_output=/well/ckb/users/aey472/projects/ckb_popgen/data/painting_output

## Here we are just going to paint the external reference samples, mainly so we can cluster them for later use as surrogates ####

module purge all
source ~/.bashrc
module purge all
mamba activate pbwt

pbwt \
	-readVcfGT ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr9.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf \
	-check \
	-stats \
	-selectSamples ${ckb_external_data}/non_CKB_oldnames.txt \
	-paint ${painting_output}/sgdp_hgdp_1kGP_CKB.chr9.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf


## Then we cluster using finestructure ##
