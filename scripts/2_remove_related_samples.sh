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

######### DO THIS BIT IF WE WANT TO FILTER OUT RELATED SAMPLES FROM EXTERNAL SAMPLES #######

#printf "sgdp_hgdp_1kGP_CKB.chr%d.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated\n" {2..22} > file_merge_list.txt

#plink2 \
#       --pfile sgdp_hgdp_1kGP_CKB.chr1.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated \
#       --pmerge-list file_merge_list.txt \
#       --make-pgen \
#       --out sgdp_hgdp_1kGP_CKB.AllChr.CKB_snps.GT.EastAsians.unrelated.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated.unrelated_2


#plink2 \
#       --make-king-table \
#       --king-table-filter 0.05 \
#       --pfile sgdp_hgdp_1kGP_CKB.AllChr.CKB_snps.GT.EastAsians.unrelated.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated.unrelated_2 \
#       --out sgdp_hgdp_1kGP_CKB.AllChr.CKB_snps.GT.EastAsians.unrelated.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated.unrelated_2


#plink2 \
#       --pfile sgdp_hgdp_1kGP_CKB.AllChr.CKB_snps.GT.EastAsians.unrelated.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated.unrelated_2 \
#       --chr ${chr} \
#       --export bcf \
#       --out sgdp_hgdp_1kGP_CKB.chr${chr}.CKB_snps.GT.EastAsians.unrelated.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated.unrelated_2



#plink2 \
# --pfile sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated \
# --export bcf \
# --out sgdp_hgdp_1kGP_CKB.chr${chr}.CKB_snps.GT.EastAsians.unrelated.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated


module purge all
mamba activate pbwt

pbwt \
        -check \
        -stats \
        -readVcfGT sgdp_hgdp_1kGP_CKB.chr${chr}.CKB_snps.GT.EastAsians.unrelated.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated.bcf \
        -paint sgdp_hgdp_1kGP_CKB.chr${chr}.CKB_snps.GT.EastAsians.unrelated.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated

rm sgdp_hgdp_1kGP_CKB.chr${chr}.CKB_snps.GT.EastAsians.unrelated.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated.regionsquaredchunkcounts.out
rm sgdp_hgdp_1kGP_CKB.chr${chr}.CKB_snps.GT.EastAsians.unrelated.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated.regionchunkcounts.out

gzip sgdp_hgdp_1kGP_CKB.chr${chr}.CKB_snps.GT.EastAsians.unrelated.rmdup.conformed.phased.newnames.maf_filter.relfree.unrelated.chunkcounts.out
