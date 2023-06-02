#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J SOURCEFIND
#SBATCH -o SOURCEFIND_%j.out
#SBATCH -e SOURCEFIND_%j.err
#SBATCH -p short
#SBATCH -c 1
#SBATCH --array 1-141

#region=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' regions.txt)

source directories.config
source ~/.bashrc

stem=5000_PC_midpoints

#Rscript ${programs}/get_tree_xml.R \
#	${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.xml \
#	${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.clusters.txt

#Rscript ${programs}/combine_chunklengths_SF.R \
#	-c ${painting_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.chunklengths.out.gz \
#	-p ${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.clusters.txt \
#	-o ${painting_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.chunklengths.combined.out.gz
	

#cut -f2- -d' ' ${painting_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.chunklengths.combined.out | head -n1 | tr " " "\n" | awk '{print $0,$NF,1}' > ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.clusters.chunklengths.combined.idfile.txt

#grep 'x_' ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.5000_PC_midpoints.clusters.chunklengths.combined.idfile.txt | cut -d' ' -f1 | uniq | sort -V > ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.clusters.unique.txt

cluster=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.clusters.unique.txt)

Rscript $programs/sourcefindV2/sourcefindv2.R \
  -c ${painting_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.chunklengths.combined.out \
  -p ${sourcefind_data}/paramfile_noHanBurmaSurrogate.txt \
  -i ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.clusters.chunklengths.combined.idfile.txt \
  -o ${sourcefind_data}/${cluster}_noHanBurmaSurrogate_${stem}.txt \
  -t ${cluster}


#Rscript $programs/sourcefindV2/sourcefindv2.R \
#  -c ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.txt \
#  -p ${sourcefind_data}/paramfile_noHanSurrogate_2000_random.clusters.txt \
#  -i ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.idfile.txt \
#  -o ${sourcefind_data}/${cluster}_local.2000_random.clusters \
#  -t ${cluster}

#Rscript $programs/sourcefindV2/sourcefindv2.R \
#  -c ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.txt \
#  -p ${sourcefind_data}/paramfile_noHanSurrogate_noTujia_2000_random.clusters.txt \
#  -i ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.idfile.txt \
#  -o ${sourcefind_data}/${cluster}_local.2000_random.clusters_noTujia \
#  -t ${cluster}
