#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J pcm_greedyFSsubset
#SBATCH -o pcm_greedyFSsubset_%A_%a.out
#SBATCH -e pcm_greedyFSsubset_%A_%a.err
#SBATCH -p short
#SBATCH --array 1-7
#SBATCH -c 8

source directories.config 

########## test diff sample sizes for greedy FS ###############

line=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' sample_names_FSgreedy_test_chr.txt)
samples=$(echo $line | cut -d' ' -f1)
stem=$(basename $samples | sed 's/CKB_samples_greedy_//g' | sed 's/\./_/g' | sed 's/_txt//g')
chr=$(echo $line | cut -d' ' -f2)

module purge all
source ~/.bashrc
#module purge all
#conda activate pbwt

#pbwt \
# -readVcfGT ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf \
# -check \
# -selectSamples ${samples} \
# -stats \
# -paint ${painting_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}

#rm ${painting_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.regionsquaredchunkcounts.out
#rm ${painting_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.regionchunkcounts.out

#gzip ${painting_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.chunkcounts.out
#gzip ${painting_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.chunklengths.out

#line=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' greedy_fs_sizes.txt)
#n=$(echo $line | cut -d' ' -f1)
#stem=sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset.PC_midpoints

#Rscript ${programs}/merge_chunklengths.R \
# -n ${samples} \
# -p ${painting_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.chr \
# -a .AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.chunklengths.out.gz \
# -c "1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
# -o ${painting_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.chunklengths.out.gz


chunkcounts=${painting_output}/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}.chunkcounts.out
stem_fs=fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.${stem}

programs=/well/ckb/users/aey472/projects/ckb_popgen/programs
fs_out=/well/ckb/users/aey472/projects/ckb_popgen/data/finestructure_output

bash ${programs}/finestructuregreedy.sh -a "-T 1" -R ${chunkcounts} ${fs_out}/${stem_fs}.xml








