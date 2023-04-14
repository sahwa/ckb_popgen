#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J pbwt_ea
#SBATCH -o zpbwt_ea_%j.out
#SBATCH -e zpbwt_ea_%j.err
#SBATCH -p short
#SBATCH --array 1-22
#SBATCH -c 32

module purge all
module load PLINK/2.00a3.1-GCC-11.2.0

## we really want to prune down the number of SNPs since we don't need them
## best to use a MAF filter 
## Also remove any nonlocal individuals (see paper), any on acgt SNPs and retain the relative free CKB subset

plink2 \
       --vcf sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.vcf.gz \
       --keep rel_free_nonCKB_samples.txt \
       --remove ${nonlocal} \
       --snps-only just-acgt \
       --maf 0.1 \
       --make-pgen \
       --out sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated

## convert to bcf format for the PBWT-paint step

plink2 \
 --pfile sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated \
 --export bcf \
 --out sgdp_hgdp_1kGP_CKB.chr${chr}.CKB_snps.GT.EastAsians.unrelated.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated

