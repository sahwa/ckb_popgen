#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J MOSAIC
#SBATCH -o MOSAIC_%A_%a.out
#SBATCH -e MOSAIC_%A_%a.err
#SBATCH -p short
#SBATCH --array 1-33
#SBATCH -c 8

source directories.config
source ~/.bashrc

chr=${SLURM_ARRAY_TASK_ID}
#n=500 
#keep_CKB_samples=/well/ckb/users/aey472/projects/ckb_popgen/data/finestructure_output/CKB_samples_greedy_${n}.PC_midpoints.txt
#keep_external_samples=${mosaic_data}/keep_external_samples.txt
#cat ${keep_CKB_samples} ${keep_external_samples} > ${mosaic_data}/mosiac_ckb_external_keep_samples.txt

#module purge all 
#module load BCFtools/1.17-GCC-12.2.0

#bcftools view \
#	-S ${mosaic_data}/mosiac_ckb_external_keep_samples.txt \
#	-O u \
#	${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.vcf.gz | \
#bcftools convert \
#	--hapsample ${mosaic_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.MOSAIC_samples.vcf.gz

#Rscript ${programs}/get_tree_xml.R ${finestructure_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_500_subset.PC_midpoints.xml ${finestructure_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_500_subset.PC_midpoints.popdf.txt


#Rscript ${programs}/MOSAIC/convert_haps_SM.R \
#	${mosaic_data}/ \
#	${chr} \
#	sgdp_hgdp_1kGP_CKB.chr \
#	.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.MOSAIC_samples.vcf.gz.hap.gz \
#	sgdp_hgdp_1kGP_CKB.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.MOSAIC_samples.vcf.gz.samples.pops \
#	${mosaic_data}/

cd ${mosaic_data}

cluster=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' pcmidpoints_500_clusters.txt)

Rscript ${programs}/MOSAIC/mosaic.R \
	--chromosomes 1:22 \
	--ancestries 2 \
	--panels "Balochi Bengali Bougainville British Cambodian Chukchi Finnish French Hawaiian Japanese KinhVietnamese Korean Mongolian Kyrgyz Russian Thai Yakut" \
	--maxcores 8 \
	${cluster} \
	${mosaic_data}/
