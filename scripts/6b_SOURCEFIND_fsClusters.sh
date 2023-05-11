#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J SOURCEFIND
#SBATCH -o SOURCEFIND_%j.out
#SBATCH -e SOURCEFIND_%j.err
#SBATCH -p short
#SBATCH -c 1
#SBATCH --array 1-10

#region=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' regions.txt)

source directories.config
source ~/.bashrc

Rscript ${programs}/get_tree_xml.R \
	${finestructure_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.xml \
	${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.txt

Rscript ${programs}/combine_chunklengths_SF.R \
	-c ${painting_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.chunklengths.out.gz \
	-p ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.txt \
	-o sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.txt
	

#cut -f2- -d' ' sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.txt  | head -n1 | tr " " "\n" | awk '{print $0,$NF,1}' > sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.idfile.txt

cluster=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.unique.txt)


Rscript $programs/sourcefindV2/sourcefindv2.R \
  -c ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.txt \
  -p ${sourcefind_data}/paramfile_noHanSurrogate_2000_random.clusters.txt \
  -i ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.idfile.txt \
  -o ${sourcefind_data}/${cluster}_local.2000_random.clusters \
  -t ${cluster}







##Rscript ${sf_dir}/sourcefindv2.R \
#	-c ${painting_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.chunklengths.out.casted.popaverage.gz \
#	-p ${sf_out}/paramfile.txt \
#	-i ${sf_out}/idfile.txt \
#	-o ${sf_out}/${region}.txt \
#	-t ${region}

######### no HAN ancestry ###########

#Rscript ${sf_dir}/sourcefindv2.R \
#  -c ${painting_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.chunklengths.out.casted.popaverage.gz \
#  -p ${sf_out}/paramfile_noHanSurrogate.txt \
#  -i ${sf_out}/idfile.txt \
#  -o ${sf_out}/${region}_noHanSurrogate.txt \
#  -t ${region}

######### no HAN ancestry but including CKB regions as surrogates ########

Rscript ${sf_dir}/sourcefindv2.R \
  -c ${painting_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.chunklengths.out.casted.popaverage.gz \
  -p ${sf_out}/paramfile_noHanSurrogate_CKBSurrogates.txt \
  -i ${sf_out}/idfile.txt \
  -o ${sf_out}/${region}_noHanSurrogate_CKBSurrogates.txt \
  -t ${region}
