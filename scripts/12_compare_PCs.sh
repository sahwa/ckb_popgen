#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J TVD_perm
#SBATCH -o compare_PCs_%A_%a.out
#SBATCH -e compare_PCs_%A_%a.err
#SBATCH -p short
#SBATCH -c 24
#SBATCH -a 1

source directories.config
source ~/.bashrc

gtypes=/well/ckb/shared/filesystem/genetic_data/CKB_genotype/b38/m4_b38_qced

module purge all && module load PLINK/2.00a3.1-GCC-11.2.0

#plink2 \
#	--bfile ${gtypes} \
#	--maf 0.01 \
#	--indep-pairwise 50 5 0.2 \
#	--keep-fam relfree_local.txt \
#	--out /well/ckb/users/aey472/projects/ckb_popgen/data/PCS/m4_b38_qced.pruned

plink2 \
	--bfile ${gtypes} \
	--keep-fam relfree_local.txt \
	--extract /well/ckb/users/aey472/projects/ckb_popgen/data/PCS/m4_b38_qced.pruned.prune.in \
	--pca 100 \
	--out /well/ckb/users/aey472/projects/ckb_popgen/data/PCS/m4_b38_qced	\
	--threads 24


#### Fst estimation ####

pruned=/well/ckb/shared/filesystem/genetic_data/CKB_genotype/b38/m4_b38_qced.pruned


plink \
	--bfile ${pruned} \	
	--within /well/ckb/users/aey472/projects/ckb_popgen/data/Fst_TVD/within_file_5000_PC_midpoints.txt \
	--fst 
