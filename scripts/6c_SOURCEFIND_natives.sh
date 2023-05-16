#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J SOURCEFIND
#SBATCH -o SOURCEFIND_%j.out
#SBATCH -e SOURCEFIND_%j.err
#SBATCH -p short
#SBATCH -c 1
#SBATCH --array 1-78

#region=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' regions.txt)

source directories.config
source ~/.bashrc

cluster=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.unique.txt)

Rscript $programs/sourcefindV2/sourcefindv2.R \
  -c ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.txt \
  -p ${sourcefind_data}/paramfile_noHanSurrogate_2000_random.clusters.txt \
  -i ${sourcefind_data}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.2000_random.clusters.chunklengths.combined.idfile.txt \
  -o ${sourcefind_data}/${cluster}_local.2000_random.clusters \
  -t ${cluster}

