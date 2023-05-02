#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J paint_RCstrat
#SBATCH -o paint_RCstrat_$SLURM_ARRAY_TASK_ID.out
#SBATCH -e paint_RCstrat_$%SLURM_ARRAY_TASK_ID.err
#SBATCH -p short
#SBATCH -c 3
#SBATCH --array 1-10

# ###########################################################################################
#	                               Paint just CKB samples against each other                  #
#############################################################################################

source ~/.bashrc
conda activate pbwt

line=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' RCnames_chr.txt)
RC=$(echo $line | cut -d' ' -f1)
chr=$(echo $line | cut -d' ' -f2)

source directories.config

#pbwt \
#	-readVcfGT ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf \
#	-check \
#	-selectSamples ${rc_data}/${RC}_GSID.txt\
#	-stats \
#	-paint ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.${RC}

#rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.${RC}.regionsquaredchunkcounts.out
#rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.${RC}.regionchunkcounts.out

#gzip -f ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.${RC}.chunkcounts.out
#gzip -f ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.${RC}.chunklengths.out

#################### merge #############

cd ${painting_output}

Rscript ${programs}/merge_chunklengths.R \
  -n ${rc_data}/${RC}_GSID.relfree.txt \
  -p ${painting_output}/sgdp_hgdp_1kGP_CKB.chr \
  -a .AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.${RC}.chunklengths.out.gz \
  -c "1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
  -o sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.${RC}.chunklengths.out

Rscript ${programs}/merge_chunklengths.R \
  -n ${rc_data}/${RC}_GSID.relfree.txt \
  -p ${painting_output}/sgdp_hgdp_1kGP_CKB.chr \
  -a .AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.${RC}.chunkcounts.out.gz \
  -c "1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
  -o sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.${RC}.chunkcounts.out \
	-x TRUE


