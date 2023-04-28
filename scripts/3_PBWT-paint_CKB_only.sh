#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J greedyFSsubset
#SBATCH -o greedyFSsubset_%j.out
#SBATCH -e greedyFSsubset_%j.err
#SBATCH -p short
#SBATCH -c 12
#SBATCH --array 1-4

# ###########################################################################################
#	                               Paint just CKB samples against each other                  #
#############################################################################################

#chr=${SLURM_ARRAY_TASK_ID}

#module purge all
#source ~/.bashrc
#module purge all
#mamba activate pbwt

external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/external_data
ckb_external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external
painting_output=/well/ckb/users/aey472/projects/ckb_popgen/data/painting_output
programs=/well/ckb/users/aey472/projects/ckb_popgen/programs

#rel_free=/well/ckb/shared/filesystem/metadata/sample_inclusion_exclusion_lists/relative_free/rel_free.ls

#pbwt \
#	-readVcfGT ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf \
#	-check \
#	-selectSamples ${ckb_external_data}/relfree_local.txt \
#	-stats \
#	-paint ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree

#rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.regionsquaredchunkcounts.out
#rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.regionchunkcounts.out

#gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunkcounts.out
#gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunklengths.out

#################### merge #############

#cd ${painting_output}

#Rscript ${programs}/merge_chunklengths.R \
#	-n "/well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external/relfree_local.RC_ID.txt" \
#	-p "sgdp_hgdp_1kGP_CKB.chr" \
#	-a ".AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunkcounts.out.gz" \
#	-c "1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
#	-o "sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunkcounts.out.gz"

#Rscript ${programs}/merge_chunklengths.R \
#  -n "/well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external/relfree_local.RC_ID.txt" \
#  -p "sgdp_hgdp_1kGP_CKB.chr" \
#  -a ".AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunklengths.out.gz" \
#  -c "1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
#  -o "sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunklengths.out.gz"

######### run greedy fs ############

chunkcounts=${painting_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunkcounts.out
programs=/well/ckb/users/aey472/projects/ckb_popgen/programs
fs_out=/well/ckb/users/aey472/projects/ckb_popgen/data/finestructure_output

#bash ${programs}/finestructuregreedy.sh ${chunkcounts} ${fs_out}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.greedy.xml

########## test diff sample sizes for greedy FS ###############

#line=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' greedy_fs_sizes.txt)
#n=$(echo $line | cut -d' ' -f1)
#chr=$(echo $line | cut -d' ' -f2)

#module purge all
#source ~/.bashrc
#module purge all
#mamba activate pbwt

#pbwt \
# -readVcfGT ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf \
# -check \
# -selectSamples /well/ckb/users/aey472/projects/ckb_popgen/data/finestructure_output/CKB_samples_greedy_${n}.txt \
# -stats \
# -paint ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset

#rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset.regionsquaredchunkcounts.out
#rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset.regionchunkcounts.out

#gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset.chunkcounts.out
#gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset.chunklengths.out

line=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' greedy_fs_sizes.txt)
n=$(echo $line | cut -d' ' -f1)

#Rscript ${programs}/merge_chunklengths.R \
# -n "/well/ckb/users/aey472/projects/ckb_popgen/data/finestructure_output/CKB_samples_greedy_${n}.FS_names.txt" \
# -p "${painting_output}/sgdp_hgdp_1kGP_CKB.chr" \
# -a ".AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset.chunkcounts.out.gz" \
# -c "1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
# -o "${painting_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset.chunkcounts.out"



chunkcounts=${painting_output}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset.chunkcounts.out
programs=/well/ckb/users/aey472/projects/ckb_popgen/programs
fs_out=/well/ckb/users/aey472/projects/ckb_popgen/data/finestructure_output

bash ${programs}/finestructuregreedy.sh -R ${chunkcounts} ${fs_out}/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree_${n}_subset.greedy.xml











