#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J SOURCEFIND
#SBATCH -o SOURCEFIND_%j.out
#SBATCH -e SOURCEFIND_%j.err
#SBATCH -p short
#SBATCH -c 2
#SBATCH --array 1-78

#region=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' regions.txt)

source directories.config
source ~/.bashrc

#Rscript ${programs}/get_tree_xml.R \
#	${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.xml \
#	${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.txt

#Rscript ${programs}/combine_chunklengths_SF.R \
#	-c ${painting_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.chunklengths.out.gz \
#	-p ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.txt \
#	-o ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.txt
	

#cut -f2- -d' ' ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.txt  | head -n1 | tr " " "\n" | awk '{print $0,$NF,1}' > ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.idfile.txt
#
#cut -d' ' -f2 ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.txt  | uniq | sort > ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.unique.txt

cluster=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.unique.txt)

#Rscript $programs/sourcefindV2/sourcefindv2.R \
#  -c ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.txt \
#  -p ${sourcefind_data}/paramfile_noHanSurrogate_2000_random.clusters.txt \
#  -i ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.idfile.txt \
#  -o ${sourcefind_data}/${cluster}_local.2000_random.clusters \
#  -t ${cluster}

Rscript $programs/sourcefindV2/sourcefindv2.R \
  -c ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.txt \
  -p ${sourcefind_data}/paramfile_noHanSurrogate_noTujia_2000_random.clusters.txt \
  -i ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.idfile.txt \
  -o ${sourcefind_data}/${cluster}_local.2000_random.clusters_noTujia \
  -t ${cluster}
