#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J extractHO
#SBATCH -o extractHO_%A_%a.out
#SBATCH -e extractHO_%A_%a.err
#SBATCH -p short
#SBATCH -c 42
#SBATCH -a 1

source directories.config
source ~/.bashrc

chr=${SLURM_ARRAY_TASK_ID}

ho=/well/ckb/users/aey472/projects/tskit/data/snp_comparison/Axiom_GW_HuOrigin.na35.lifted.bed
pgen=/well/ckb/shared/filesystem/genetic_data/CKB_imputed/v2.0_b38_pgen
ho_dir=/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsSubset

beagle=${programs}/beagle.22Jul22.46e.jar

#module purge all && module load PLINK/2.00a3.1-GCC-11.2.0

plink2 \
	--pfile ${pgen}/${chr} \
	--extract bed0 ${ho} \
	--min-alleles 2 \
	--max-alleles 2 \
	--snps-only just-acgt \
	--make-pgen \
	--out ${ho_dir}/CKB_imputed_v2_b38_chr${chr}

## calc allele frequencies so we can decide how best to set a filter #$

#plink2 \
#	--pfile ${ho_dir}/CKB_imputed_v2_b38_chr${chr} \
#	--freq \
#	--out ${ho_dir}/CKB_imputed_v2_b38_chr${chr}


#plink2 \
#	--pfile ${ho_dir}/CKB_imputed_v2_b38_chr${chr} \
#	--maf 0.01 \
#	--indep-pairwise 50 5 0.2 \
#	--out ${ho_dir}/CKB_imputed_v2_b38_chr${chr}

#plink2 \
#  --pfile ${ho_dir}/CKB_imputed_v2_b38_chr${chr} \
#  --extract ${ho_dir}/CKB_imputed_v2_b38_chr${chr}.prune.in \
#  --make-pgen \
#	--out ${ho_dir}/CKB_imputed_v2_b38_chr${chr}.pruned

#printf "${ho_dir}/CKB_imputed_v2_b38_chr%d.pruned\n" `seq 3 22` > ${ho_dir}/CKB_imputed_v2_b38_pmerge_list.txt

#plink2 \
#	--pfile ${ho_dir}/CKB_imputed_v2_b38_chr2.pruned \
#	--pmerge-list	${ho_dir}/CKB_imputed_v2_b38_pmerge_list.txt \
#	--make-pgen \
#	--keep-fam /well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external/relfree_local.txt \
#	--out ${ho_dir}/CKB_imputed_v2_b38_AllChr.pruned


#plink2 \
#  --pfile ${ho_dir}/CKB_imputed_v2_b38_AllChr.pruned \
#	--pca \
#	--out ${ho_dir}/CKB_imputed_v2_b38_AllChr.pruned

#### filter MAF for painting and convert to bcf ####

#plink2 \
#  --pfile ${ho_dir}/CKB_imputed_v2_b38_chr${chr} \
#	--maf 0.05 \
#	--min-alleles 2 \
#	--max-alleles 2 \
#	--snps-only just-acgt \
#	--export vcf \
#	--out ${ho_dir}/CKB_imputed_v2_b38_chr${chr}_maf_filter

#gzip ${ho_dir}/CKB_imputed_v2_b38_chr${chr}_maf_filter.vcf

#java -jar ${beagle} \
#       gt=${ho_dir}/CKB_imputed_v2_b38_chr${chr}_maf_filter.vcf.gz \
#       chrom=${chr} \
#       map=${gen_maps}/plink.chr${chr}.GRCh38.map \
#       nthreads=32 \
#       out=${ho_dir}/CKB_imputed_v2_b38_chr${chr}_maf_filter.phased

#module purge all && module load BCFtools/1.17-GCC-12.2.0
#bcftools reheader -s newnames_vcf.txt ${ho_dir}/CKB_imputed_v2_b38_chr${chr}_maf_filter.phased.vcf.gz > ${ho_dir}/CKB_imputed_v2_b38_chr${chr}_maf_filter.phased.vcf.gz.tmp && mv ${ho_dir}/CKB_imputed_v2_b38_chr${chr}_maf_filter.phased.vcf.gz.tmp ${ho_dir}/CKB_imputed_v2_b38_chr${chr}_maf_filter.phased.newnames.vcf.gz

#conda activate pbwt

#pbwt \
#	-readVcfGT ${ho_dir}/CKB_imputed_v2_b38_chr${chr}_maf_filter.phased.newnames.vcf.gz \
#	-check \
#	-selectSamples ${ckb_external_data}/relfree_local.txt \
#	-stats \
#	-paint ${ho_dir}/CKB_imputed_v2_b38_chr${chr}_maf_filter.phased.newnames

#gzip ${ho_dir}/CKB_imputed_v2_b38_chr${chr}_maf_filter.phased.newnames.chunkcounts.out
#gzip ${ho_dir}/CKB_imputed_v2_b38_chr${chr}_maf_filter.phased.newnames.chunklengths.out

#rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.regionsquaredchunkcounts.out
#rm ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.regionchunkcounts.out

#gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunkcounts.out
#gzip ${painting_output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunklengths.out

###### merge ##########
sample_names=/well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external/relfree_local.RC_ID.txt

Rscript ${programs}/merge_chunklengths.R \
	-n ${sample_names} \
	-p "${painting_output}/sgdp_hgdp_1kGP_CKB.chr" \
	-a ".AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunkcounts.out.gz" \
	-c "2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
	-o "sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.HumanOrigins.chunkcounts.out.gz"

#Rscript ${programs}/merge_chunklengths.R \
#  -n ${sample_names} \
#  -p "sgdp_hgdp_1kGP_CKB.chr" \
#  -a ".AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunklengths.out.gz" \
#  -c "1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
 # -o "sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.CKB_only_relfree.chunklengths.out.gz"
