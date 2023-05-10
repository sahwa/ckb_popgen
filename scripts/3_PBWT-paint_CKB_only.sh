#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J mergeCKB
#SBATCH -o mergeCKB_%A_%a.out
#SBATCH -e mergeCKB_%A_%a.err
#SBATCH -p short
#SBATCH --array 1
#SBATCH -c 16

# ###########################################################################################
#	                               Paint just CKB samples against each other                  #
#############################################################################################

#chr=${SLURM_ARRAY_TASK_ID}

#module purge all
#source ~/.bashrc
#module purge all
#mamba activate pbwt

source directories.config
source ~/.bashrc

#pbwt \
#	-readVcfGT ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf \
#	-check \
#	-selectSamples ${ckb_external_data}/relfree_local.txt \
#	-paint ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree

#rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.regionsquaredchunkcounts.out
#rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.regionchunkcounts.out

#gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunkcounts.out
#gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunklengths.out

#################### merge #############

cd ${painting_output}

sample_names=/well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external/relfree_local.RC_ID.txt

Rscript ${programs}/merge_chunklengths.R \
	-n ${sample_names} \
	-p "sgdp_hgdp_1kGP_CKB.chr" \
	-a ".AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunkcounts.out.gz" \
	-c "1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
	-o "sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunkcounts.out.gz"

Rscript ${programs}/merge_chunklengths.R \
  -n ${sample_names} \
  -p "sgdp_hgdp_1kGP_CKB.chr" \
  -a ".AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunklengths.out.gz" \
  -c "1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
  -o "sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunklengths.out.gz"

#bash ${programs}/finestructuregreedy.sh -R ${chunkcounts} ${fs_out}/${stem}.xml









