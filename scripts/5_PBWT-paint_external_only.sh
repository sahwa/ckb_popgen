#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J pbwt_only
#SBATCH -o pbwt_only_%a_%A.out
#SBATCH -e pbwt_only_%a_%A.err
#SBATCH -p short
#SBATCH -c 2
#SBATCH --array 1

chr=${SLURM_ARRAY_TASK_ID}

## dirs 

ckb_external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external
painting_output=/well/ckb/users/aey472/projects/ckb_popgen/data/painting_output
programs=/well/ckb/users/aey472/projects/ckb_popgen/programs
fs_output=/well/ckb/users/aey472/projects/ckb_popgen/data/finestructure_output

## Here we are just going to paint the external reference samples, mainly so we can cluster them for later use as surrogates ####

module purge all
source ~/.bashrc
module purge all
conda activate pbwt

#pbwt \
#	-readVcfGT ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf \
#	-check \
#	-stats \
#	-selectSamples ${ckb_external_data}/external_sample_final_names.no_admixed.txt \
#	-paint ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.external_only.no_admixed


#Rscript ${programs}/merge_chunklengths.R \
# -n ${ckb_external_data}/external_sample_final_names.no_admixed.sample_names.txt \
# -p ${painting_output}/sgdp_hgdp_1kGP_CKB.chr \
# -a .AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.external_only.no_admixed.chunkcounts.out \
# -c "1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
# -o ${painting_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.external_only.no_admixed.chunkcounts.out

## Then we cluster using finestructure ##

chunkcounts=${painting_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.external_only.no_admixed.chunkcounts.out
stem=sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.external_only.no_admixed

bash ${programs}/finestructuregreedy.sh -a "-T 1" -R ${chunkcounts} ${finestructure_output}/${stem}.xml
