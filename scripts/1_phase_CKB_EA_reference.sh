#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J pbwt_ea
#SBATCH -o zpbwt_ea_%j.out
#SBATCH -e zpbwt_ea_%j.err
#SBATCH -p short
#SBATCH --array 1-22
#SBATCH -c 6

chr=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' chr_list.txt)
module purge all && source ~/.bashrc

#### lists #####

nonlocal=/well/ckb/shared/filesystem/metadata/sample_inclusion_exclusion_lists/non_local_samples/immigrant.ls
rel_free=/well/ckb/shared/filesystem/metadata/sample_inclusion_exclusion_lists/relative_free/rel_free.ls

#### directories ####

external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/external_data
ckb_external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external
gen_maps=/well/ckb/users/aey472/projects/ckb_popgen/data/other_files/gen_maps
programs=/well/ckb/users/aey472/projects/ckb_popgen/programs

### split up reference data into chromosomes ###

cd ${ckb_external_data}

#module purge all
#module load BCFtools/1.17-GCC-12.2.0

#bcftools index ${external_data}/sgdp_hgdp_1kGP.AllChr.CKB_snps.GT.no_duplicates.vcf.gz

#bcftools view -r ${chr} ${external_data}/sgdp_hgdp_1kGP.AllChr.CKB_snps.GT.no_duplicates.vcf.gz -Oz > sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.vcf.gz
#bcftools index sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.vcf.gz

#### merge external reference with CKB ###

#conform=conform-gt.24May16.cee.jar
#beagle=beagle.22Jul22.46e.jar

## remove any duplicated SNPs and keep only biallelics ##

#bcftools norm \
#	--rm-dup snps \
#	sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.vcf.gz | \
#bcftools view \
#	-M 2 \
#	-Oz > sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.vcf.gz

conform=${programs}/conform-gt.24May16.cee.jar

## important - need to make sure the alleles are on the same strand with CKB or else we can't merge ###

#java -jar ${conform} \
#    gt=sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.vcf.gz \
#    ref=m4_b38_qced_${chr}.vcf.gz \
#    match=POS \
#    chrom=${chr} \
#    out=sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed


## index the output again ##

#bcftools index -f sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.vcf.gz
#bcftools index -f m4_b38_qced_${chr}.vcf.gz

## finally merge in the EA ref and CKB ##

#bcftools merge m4_b38_qced_${chr}.vcf.gz sgdp_hgdp_1kGP.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.vcf.gz -Oz > sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.vcf.gz

## phase using beagle5 ##
beagle=${programs}/beagle.22Jul22.46e.jar

java -jar ${beagle} \
       gt=sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.vcf.gz \
       chrom=${chr} \
       map=${gen_maps}/plink.chr${chr}.GRCh38.map \
       nthreads=16 \
       out=sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased

