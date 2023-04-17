#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J pbwt_representative
#SBATCH -o pbwt_representative_%j.out
#SBATCH -e pbwt_representative_%j.err
#SBATCH -p short
#SBATCH -c 4
#SBATCH --array 1-22%4

chr=${SLURM_ARRAY_TASK_ID}

module purge all
source ~/.bashrc
module purge all
mamba activate pbwt

###### paint entire CKB cohort as one #######

rel_free=/well/ckb/shared/filesystem/metadata/sample_inclusion_exclusion_lists/relative_free/rel_free.ls

external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/external_data
ckb_external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external
painting_output=/well/ckb/users/aey472/projects/ckb_popgen/data/painting_output

pbwt \
	-readVcfGT ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf \
	-check \
	-stats \
	-selectSamples ${rel_free} \
	-paint ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree

rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.regionsquaredchunkcounts.out
rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.regionchunkcounts.out

gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunkcounts.out
gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunklengths.out
