#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J ckbexternal_merge_counts
#SBATCH -o ckbexternal_merge_counts_%j.out
#SBATCH -e ckbexternal_merge_counts_%j.err
#SBATCH -p short
#SBATCH -c 16
#SBATCH --array 1

#############################################################################################
# Paint all unrelated CKB samples and most external reference samples for use in SOURCEFIND #
#############################################################################################

chr=${SLURM_ARRAY_TASK_ID}

module purge all
source ~/.bashrc
#module purge all
#mamba activate pbwt

external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/external_data
ckb_external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external
painting_output=/well/ckb/users/aey472/projects/ckb_popgen/data/painting_output
programs=/well/ckb/users/aey472/projects/ckb_popgen/programs

#pbwt \
#        -readVcfGT ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf \
#        -check \
#        -stats \
#        -paint ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external

#rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.regionsquaredchunkcounts.out
#rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.regionchunkcounts.out

#gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.chunkcounts.out
#gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.chunklengths.out

####

#bcftools query -l ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf > ${ckb_external_data}/all_CKB_external.sample_names.txt
#sample_names=${ckb_external_data}/all_CKB_external.sample_names.txt

cd ${painting_output}

Rscript ${programs}/merge_chunklengths.R \
       -n "all_CKB_external.sample_names.CKB_RC_ID.txt" \
       -p "sgdp_hgdp_1kGP_CKB.chr" \
       -a ".AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.chunkcounts.out.gz" \
       -c "1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
       -o "sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.chunkcounts.out.gz"

#Rscript ${programs}/merge_chunklengths.R \
#  -n "all_CKB_external.sample_names.CKB_RC_ID.txt" \
#  -p "sgdp_hgdp_1kGP_CKB.chr" \
#  -a ".AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.chunklengths.out.gz" \
#  -c "1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
#  -o "sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.chunklengths.out.gz"
