#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J pbwt_representative
#SBATCH -o pbwt_representative_%j.out
#SBATCH -e pbwt_representative_%j.err
#SBATCH -p short
#SBATCH -c 32
#SBATCH --array 1-22

module purge all
source ~/.bashrc
module purge all
mamba activate pbwt

###### paint entire CKB cohort as one #######


pbwt \
	-readVcfGT sgdp_hgdp_1kGP_CKB.chr${chr}.CKB_snps.GT.EastAsians.unrelated.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated.bcf \
	-check \
	-stats \
	-selectSamples CKB_only_samples.txt \
	-paint m4_b38_qced_AllChr_phased.filtered.chr${chr}.${stem}

Rscript merge_PBWT_chunks.R
