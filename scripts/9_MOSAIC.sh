#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J MOSAIC
#SBATCH -o MOSAIC_%A_%a.out
#SBATCH -e MOSAIC_%A_%a.err
#SBATCH -p short
#SBATCH --array 1-78
#SBATCH -c 32

source directories.config
source ~/.bashrc

chr=${SLURM_ARRAY_TASK_ID}

#Rscript ${programs}/get_tree_xml.R \
#	${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.xml \
#	${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.popdf.txt

#cut -f 1 -d' ' ${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.popdf.txt > ${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.samples.txt

keep_CKB_samples=${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.samples.txt
keep_external_samples=${mosaic_data}/keep_external_samples.txt
#cat ${keep_CKB_samples} ${keep_external_samples} > ${mosaic_data}/mosiac_ckb_external_keep_samples.txt

#module purge all 
#module load BCFtools/1.17-GCC-12.2.0

#### only need to do this once convert 

#bcftools view -Oz ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf > ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.vcf.gz

#bcftools view \
#	-S ${mosaic_data}/mosiac_ckb_external_keep_samples.txt \
#	-O u \
#	${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.vcf.gz | \
#bcftools convert \
#	--hapsample ${mosaic_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.MOSAIC_samples.vcf.gz

#module purge all
#source ~/.bashrc

#Rscript ${programs}/MOSAIC/convert_haps_SM.R \
#	${mosaic_data}/ \
#	${chr} \
#	sgdp_hgdp_1kGP_CKB.chr \
#	.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.MOSAIC_samples.vcf.gz.hap.gz \
#	sgdp_hgdp_1kGP_CKB.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.MOSAIC_samples.vcf.gz.samples.pops \
#	${mosaic_data}/

#if grep -q MOSAIC_RESULTS MOSAIC_15937338_${SLURM_ARRAY_TASK_ID}.out; then
#    echo already run
#		exit 0
#else
#    echo not run
#fi

cd ${mosaic_data}

#cut -d' ' -f2 ${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.popdf.txt | uniq | sort > mosaic_CKB_2000_random.pops.txt

cluster=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' mosaic_CKB_2000_random.pops.txt)

Rscript ${programs}/MOSAIC/mosaic.R \
	--chromosomes 10:22 \
	--ancestries 2 \
	--panels "Balochi British Cambodian Chukchi Hawaiian Japanese KinhVietnamese Korean Mongolian Tujia Thai" \
	--maxcores 4 \
	${cluster} \
	${mosaic_data}/
