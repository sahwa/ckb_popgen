#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J pcm_greedyFSsubset
#SBATCH -o pcm_greedyFSsubset_%A_%a.out
#SBATCH -e pcm_greedyFSsubset_%A_%a.err
#SBATCH -p long
#SBATCH --array 1-8
#SBATCH -c 8

#chunkcounts=${painting_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset.chunkcounts.out
#programs=/well/ckb/users/aey472/projects/ckb_popgen/programs
#fs_out=/well/ckb/users/aey472/projects/ckb_popgen/data/finestructure_output

#bash ${programs}/finestructuregreedy.sh -R ${chunkcounts} ${fs_out}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset.greedy.xml


########## test diff sample sizes for greedy FS ###############

#line=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' greedy_fs_sizes.txt)
#n=$(echo $line | cut -d' ' -f1)
#chr=$(echo $line | cut -d' ' -f2)

#stem=sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset.PC_midpoints

#module purge all
#source ~/.bashrc
#module purge all
#conda activate pbwt

#pbwt \
# -readVcfGT ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf \
# -check \
# -selectSamples /well/ckb/users/aey472/projects/ckb_popgen/data/finestructure_output/CKB_samples_greedy_${n}.PC_midpoints.txt \
# -stats \
# -paint ${painting_output}/${stem}

#rm ${painting_output}/${stem}.regionsquaredchunkcounts.out
#rm ${painting_output}/${stem}.regionchunkcounts.out

#gzip ${painting_output}/${stem}.chunkcounts.out
#gzip ${painting_output}/${stem}.chunklengths.out

#line=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' greedy_fs_sizes.txt)
#n=$(echo $line | cut -d' ' -f1)
#stem=sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset.PC_midpoints

#Rscript ${programs}/merge_chunklengths.R \
# -n "/well/ckb/users/aey472/projects/ckb_popgen/data/finestructure_output/CKB_samples_greedy_${n}.PC_midpoints.FS_names.txt" \
# -p "${painting_output}/sgdp_hgdp_1kGP_CKB.chr" \
# -a ".AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset.PC_midpoints.chunkcounts.out.gz" \
# -c "1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
# -o "${painting_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset.PC_midpoints.chunkcounts.out"


chunkcounts=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' greedy_fs_files.txt)
stem=$(basename $chunkcounts .chunkcounts.out)

programs=/well/ckb/users/aey472/projects/ckb_popgen/programs
fs_out=/well/ckb/users/aey472/projects/ckb_popgen/data/finestructure_output

bash ${programs}/finestructuregreedy.sh -R ${chunkcounts} ${fs_out}/${stem}.xml









