#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J pbwt_paint_all
#SBATCH -o pbwt_paint_all_%j.out
#SBATCH -e pbwt_paint_all_%j.err
#SBATCH -p short
#SBATCH -c 18
#SBATCH --array 10-22%4

# ###########################################################################################
#	                               Paint just CKB samples against each other                  #
#############################################################################################

chr=${SLURM_ARRAY_TASK_ID}

module purge all
source ~/.bashrc
module purge all
mamba activate pbwt

external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/external_data
ckb_external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external
painting_output=/well/ckb/users/aey472/projects/ckb_popgen/data/painting_output

rel_free=/well/ckb/shared/filesystem/metadata/sample_inclusion_exclusion_lists/relative_free/rel_free.ls

pbwt \
	-readVcfGT ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf \
	-check \
	-selectSamples ${ckb_external_data}/relfree_local.txt \
	-stats \
	-paint ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree

rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.regionsquaredchunkcounts.out
rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.regionchunkcounts.out

gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunkcounts.out
gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunklengths.out
