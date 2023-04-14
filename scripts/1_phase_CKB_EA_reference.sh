#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J pbwt_ea
#SBATCH -o zpbwt_ea_%j.out
#SBATCH -e zpbwt_ea_%j.err
#SBATCH -p short
#SBATCH --array 1-22
#SBATCH -c 32

chr=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' chr_list.txt)
module purge all && source ~/.bashrc

#### lists #####

nonlocal=/well/ckb/shared/filesystem/metadata/sample_inclusion_exclusion_lists/non_local_samples/immigrant.ls
rel_free=/well/ckb/shared/filesystem/metadata/sample_inclusion_exclusion_lists/relative_free/rel_free.ls

### split up reference data into chromosomes ###

module purge all
module load BCFtools/1.17-GCC-12.2.0

bcftools view -r ${chr} sgdp_hgdp_1kGP.AllChr.CKB_snps.GT.no_duplicates.vcf.gz -Oz > sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.vcf.gz
bcftools index sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.vcf.gz

#### merge external reference with CKB ###

conform=conform-gt.24May16.cee.jar
beagle=beagle.22Jul22.46e.jar

## remove any duplicated SNPs and keep only biallelics ##

bcftools norm \
	--rm-dup snps \
	sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.vcf.gz | \
bcftools view \
	-M 2 \
	-Oz > sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.vcf.gz

conform=conform-gt.24May16.cee.jar

## important - need to make sure the alleles are on the same strand with CKB or else we can't merge ###

java -jar ${conform} \
    gt=sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.vcf.gz \
    ref=m4_b38_qced_${chr}.vcf.gz \
    match=POS \
    chrom=${chr} \
    out=sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed


## index the output again ##

bcftools index -f sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.vcf.gz
bcftools index -f m4_b38_qced_${chr}.vcf.gz

## finally merge in the EA ref and CKB ##

bcftools merge m4_b38_qced_${chr}.vcf.gz sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.vcf.gz -Oz > sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.vcf.gz

## phase using beagle5 ##
beagle=beagle.22Jul22.46e.jar

java -jar ${beagle} \
       gt=sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.vcf.gz \
       chrom=${chr} \
       map=plink.chr${chr}.GRCh38.map \
       nthreads=32 \
       out=sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased

#### some modifications because plink messes up the sample IDs ####

module purge all
module load BCFtools/1.17-GCC-12.2.0

## get akk CKB Ids
bcftools query -l sgdp_hgdp_1kGP_CKB.chr22.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.vcf.gz | sed '1,100706d' > non_CKB_samples.txt
bcftools query -l sgdp_hgdp_1kGP_CKB.chr22.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.vcf.gz | head -n 100706 |  cut -d'_' -f1 > new_IDs_CKB_no_underscore.txt

cat non_CKB_samples.txt ${rel_free} > rel_free_nonCKB_samples.txt
cat new_IDs_CKB_no_underscore.txt non_CKB_samples.txt > new_IDs_no_underscore.txt

bcftools reheader -s new_IDs_no_underscore.txt sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.vcf.gz > sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.vcf.gz
