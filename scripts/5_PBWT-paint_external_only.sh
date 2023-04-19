#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J finestructure_external_only
#SBATCH -o finestructure_external_only_%j.out
#SBATCH -e finestructure_external_only_%j.err
#SBATCH -p long
#SBATCH -c 1
#SBATCH --array 1-5

chr=${SLURM_ARRAY_TASK_ID}

## dirs 

ckb_external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external
painting_output=/well/ckb/users/aey472/projects/ckb_popgen/data/painting_output
programs=/well/ckb/users/aey472/projects/ckb_popgen/programs
fs_output=/well/ckb/users/aey472/projects/ckb_popgen/data/finestructure_output

## Here we are just going to paint the external reference samples, mainly so we can cluster them for later use as surrogates ####

#module purge all
#source ~/.bashrc
#module purge all
#mamba activate pbwt

#pbwt \
#	-readVcfGT ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf \
#	-check \
#	-stats \
#	-selectSamples ${ckb_external_data}/external_sample_final_names.txt \
#	-paint ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.external_only


## Then we cluster using finestructure ##

T=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' finestructure_T_params.txt)

cd ${fs_output}

mamba activate finestructure

chunkcounts=/well/ckb/users/aey472/projects/ckb_popgen/data/painting_output/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.external_only.chunkcounts.out
stem=sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.external_only
fs_output=/well/ckb/users/aey472/projects/ckb_popgen/data/finestructure_output

fs=/well/ckb/users/aey472/program_files/finestructure4/fs

${fs} fs \
	-m T \
	-T 1 \
	-t ${T} \
	${painting_output}/${stem}.chunkcounts.out ${stem}.estep20.xml ${stem}.${T}.xm0l



