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

Rscript combine_chunklengths... \
	








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
