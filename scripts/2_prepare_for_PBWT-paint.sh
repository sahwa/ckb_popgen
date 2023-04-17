#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J pbwt_ea
#SBATCH -o zpbwt_ea_%j.out
#SBATCH -e zpbwt_ea_%j.err
#SBATCH -p short
#SBATCH --array 1-22
#SBATCH -c 3


chr=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' chr_list.txt)

module purge all
#module load PLINK/2.00a3.1-GCC-11.2.0

#module load BCFtools/1.17-GCC-12.2.0

#### lists #####

nonlocal=/well/ckb/shared/filesystem/metadata/sample_inclusion_exclusion_lists/non_local_samples/immigrant.ls
rel_free=/well/ckb/shared/filesystem/metadata/sample_inclusion_exclusion_lists/relative_free/rel_free.ls

##### directories #####
external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/external_data
ckb_external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external
gen_maps=/well/ckb/users/aey472/projects/ckb_popgen/data/other_files/gen_maps
programs=/well/ckb/users/aey472/projects/ckb_popgen/programs

cd ${ckb_external_data}

#### rename the samples ####
#module purge all
#module load BCFtools/1.17-GCC-12.2.0

#bcftools query -l sgdp_hgdp_1kGP_CKB.chr22.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.vcf.gz | sed '100706q' | cut -d'_' -f1 > CKB_newnames.txt
#bcftools query -l sgdp_hgdp_1kGP_CKB.chr22.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.vcf.gz | sed '1,100706d' > non_CKB_oldnames.txt

#cat CKB_newnames.txt non_CKB_oldnames.txt > total_newnames.txt

#bcftools reheader -s total_newnames.txt sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.vcf.gz > sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.vcf.gz

### create list of the relfree subset + external samples ###

#cat ${rel_free} non_CKB_oldnames.txt > rel_free_nonCKB_samples.txt


## we really want to prune down the number of SNPs since we don't need them
## best to use a MAF filter 
## Also remove any nonlocal individuals (see paper), any on acgt SNPs and retain the relative free CKB subset

#module load PLINK/2.00a3.1-GCC-11.2.0
#plink2 \
#       --vcf sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.vcf.gz \
#       --keep rel_free_nonCKB_samples.txt \
#       --remove ${nonlocal} \
#       --snps-only just-acgt \
#       --maf 0.1 \
#       --make-pgen \
#       --out sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local


## want to estimate king relatedness for the external samples ##
## will use this later for keeping samples for the PBWT-paint 

#plink2 \
#	--vcf ${external_data}/sgdp_hgdp_1kGP.AllChr.CKB_snps.GT.no_duplicates.vcf.gz \
#	--make-king-table \
#	--king-cutoff 0.01 \
#	--out ${external_data}/sgdp_hgdp_1kGP.AllChr.CKB_snps.GT.no_duplicates

## convert to bcf format for the PBWT-paint step

#module purge all
#module load PLINK/2.00a3.1-GCC-11.2.0

#plink2 \
# --pfile sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local \
# --export bcf \
# --out sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local


if $chr == 6; do
	bcftools index sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf
	bcftools query -f '%CHROM\t%POS\n' -r 6:28510120-33480577 sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf > HLA_region_exclude.bed0
	bcftools view -T ^HLA_region_exclude.bed0 sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf -Ob > tmp_chr6 && mv tmp_chr6 sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf 
#done
