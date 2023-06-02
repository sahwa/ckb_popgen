#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J MOSAIC
#SBATCH -o MOSAIC_%A_%a.out
#SBATCH -e MOSAIC_%A_%a.err
#SBATCH -p long
#SBATCH --array 1-148
#SBATCH -c 32

source directories.config
source ~/.bashrc

chr=${SLURM_ARRAY_TASK_ID}

stem=5000_PC_midpoints

#module purge all
#module load BCFtools/1.17-GCC-12.2.0

#Rscript ${programs}/get_tree_xml.R \
#	${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.xml \
#	${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.popdf.txt
#
#cut -f 1 -d' ' ${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.popdf.txt > ${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.samples.txt

#keep_CKB_samples=${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.samples.txt

ext_keep_pop_regex="KinhVietnamese|Korean|Kyrgyz|Tujia|Thai|Tu|Burmese|Uygur|Mongolian|Japanese|Cambodian|She|DaiChinese|Lezgin|Yi|Altaian"
vcf=${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr1.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.vcf.gz

#bcftools query -l ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf | grep -E ${ext_keep_pop_regex} > ${mosaic_data}/keep_external_samples.txt
#cat ${keep_CKB_samples} ${mosaic_data}/keep_external_samples.txt > ${mosaic_data}/mosiac_ckb_external_keep_samples.txt

#### only need to do this once convert 

#bcftools view -Oz ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf > ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.vcf.gz

#bcftools view \
#	-S ${mosaic_data}/mosiac_ckb_external_keep_samples.txt \
#	-O u \
#	${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.vcf.gz | \
#bcftools convert \
#	--hapsample ${mosaic_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.MOSAIC_samples_${stem}

module purge all
source ~/.bashrc

#Rscript ${programs}/MOSAIC/convert_haps_SM.R \
#	${mosaic_data}/ \
#	${chr} \
#	sgdp_hgdp_1kGP_CKB.chr \
#	.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.MOSAIC_samples_${stem}.hap.gz \
#	sgdp_hgdp_1kGP_CKB.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.MOSAIC.5000_PC_midpoints.samples.pops \
#	${mosaic_data}/

cut -d' ' -f2 ${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.popdf.txt | uniq | sort > mosaic_CKB_${stem}.pops.txt
cluster=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' mosaic_CKB_${stem}.pops.txt)

cd ${mosaic_data}

Rscript ${programs}/MOSAIC/mosaic.R \
 --chromosomes 15:22 \
 --ancestries 2 \
 --panels "Korean Kyrgyz Tujia Thai Tu Burmese Uygur Mongolian Japanese Cambodian She DaiChinese Lezgin Yi KinhVietnamese" \
 --maxcores 4 \
 ${cluster} \
 ${mosaic_data}/

### bootstrap dates ###

#Rscript ${programs}/get_bootstraps_mosaic.R ${cluster}

#### parse logs for data ###
#touch job_${SLURM_ARRAY_TASK_ID}_mosaic_log.txt
#grep -A2 'Rst between mixing groups:' MOSAIC_17178202_${SLURM_ARRAY_TASK_ID}.out >> job_${SLURM_ARRAY_TASK_ID}_mosaic_log.txt
#grep -A2 'Fst between mixing groups:' MOSAIC_17178202_${SLURM_ARRAY_TASK_ID}.out >> job_${SLURM_ARRAY_TASK_ID}_mosaic_log.txt
#grep 'r-squared' MOSAIC_17178202_${SLURM_ARRAY_TASK_ID}.out >> job_${SLURM_ARRAY_TASK_ID}_mosaic_log.txt
