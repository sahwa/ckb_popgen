#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J mergeCKB
#SBATCH -o mergeCKB_%A_%a.out
#SBATCH -e mergeCKB_%A_%a.err
#SBATCH -p short
#SBATCH --array 1
#SBATCH -c 2

# ###########################################################################################
#	                               Paint just CKB samples against each other                  #
#############################################################################################

chr=${SLURM_ARRAY_TASK_ID}

#module purge all
#source ~/.bashrc
source ~/.bashrc

#module purge all
#conda activate pbwt

source directories.config

#ckb_samples=${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.500_random.samples.txt

#regex="Cambodian[0-9]{1,}|Japanese[0-9]{1,}|Han[0-9]{1,}|Yakut[0-9]{1,}|Tujia[0-9]{1,}|Xibo[0-9]{1,}|Yi[0-9]{1,}|Miao[0-9]{1,}|Oroqen[0-9]{1,}|Daur[0-9]{1,}|Mongolian[0-9]{1,}|Hezhen[0-9]{1,}|Dai[0-9]{1,}|Lahu[0-9]{1,}|She[0-9]{1,}|Naxi[0-9]{1,}|Tu[0-9]{1,}|Northern Han[0-9]{1,}|JPT[0-9]{1,}|KHV[0-9]{1,}|CDX[0-9]{1,}|Dai[0-9]{1,}|Han[0-9]{1,}|Atayal[0-9]{1,}|Daur[0-9]{1,}|Japanese[0-9]{1,}|Ami[0-9]{1,}|Burmese[0-9]{1,}|Cambodian[0-9]{1,}|Hezhen[0-9]{1,}|Kinh[0-9]{1,}|Korean[0-9]{1,}|Lahu[0-9]{1,}|Miao[0-9]{1,}|Oroqen[0-9]{1,}|She[0-9]{1,}|Thai[0-9]{1,}|Tu[0-9]{1,}|Tujia[0-9]{1,}|Uygur[0-9]{1,}|Xibo[0-9]{1,}|Yi[0-9]{1,}|Naxi[0-9]{1,}"
#bcftools query -l ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf | grep -E "$regex" > EAsian_external_samples.txt

#cat EAsian_external_samples.txt ${ckb_samples} > ckb_EAsian_refsamples.txt

#pbwt \
#	-readVcfGT ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf \
#	-check \
#	-selectSamples ckb_EAsian_refsamples.txt \
#	-paint ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.ckb_EAsian_refsamples

#rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.ckb_EAsian_refsamples.regionsquaredchunkcounts.out
#rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.ckb_EAsian_refsamples.regionchunkcounts.out
#
#gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.ckb_EAsian_refsamples.chunkcounts.out
#gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.ckb_EAsian_refsamples.chunklengths.out

#################### merge #############

#sample_names=${PWD}/ckb_EAsian_refsamples.txt

#cd ${painting_output}


#Rscript ${programs}/merge_chunklengths.R \
#	-n ${sample_names} \
#	-p "sgdp_hgdp_1kGP_CKB.chr" \
#	-a ".AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.ckb_EAsian_refsamples.chunkcounts.out.gz" \
#	-c "1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
#	-o "sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.ckb_EAsian_refsamples.chunkcounts.out.gz"

chunkcounts=${painting_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.ckb_EAsian_refsamples.chunkcounts.out
stem=sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.ckb_EAsian_refsamples

bash ${programs}/finestructuregreedy.sh  -a "-T 1" -R ${chunkcounts} ${finestructure_output}/${stem}.xml









