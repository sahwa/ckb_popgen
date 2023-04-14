#!/bin/bash
#$ -N jobname
#$ -P ckb.prjc
#$ -q short.qc
#$ -cwd -j y
#$ -o output_$JOB_ID.$TASK_ID.log
#$ -e error_$JOB_ID.$TASK_ID.log
#$ -pe shmem 2

#chr=$(sed -n ${SGE_TASK_ID}'{p;q}' chr_list.txt)
#source ~/.bashrc

## first liftover the SGDP samples to the right build ##

module purge all
module load picard/2.23.0-Java-11

file=$(sed -n ${SGE_TASK_ID}'{p;q}' sgdp_samples.txt)
base=$(basename $file .vcf.gz)

java -jar $EBROOTPICARD/picard.jar LiftoverVcf \
       I=${file} \
       O=${base}.lifted.vcf.gz \
       CHAIN=b37ToHg38.over.chain \
       REJECT=${base}.reject.vcf.gz \
       R=Homo_sapiens_assembly38.fasta


## extract only positions present in CKB ##

module purge all
module load BCFtools/1.17-GCC-12.2.0

bcftools concat hgdp_wgs.20190516.full.chr{1..22}.vcf.gz -Ou | bcftools view -T ckb_chr_pos.chr.txt -Ob > hgdp_wgs.20190516.full.AllChr.ckb_pos.bcf
bcftools concat 1kGP_high_coverage_Illumina.chr{1..22}.filtered.SNV_INDEL_SV_phased_panel.vcf.gz -Ou | bcftools view -T ckb_chr_pos.chr.txt -Ob  > 1kGP_high_coverage_Illumina.AllChr.filtered.SNV_INDEL_SV_phased_panel.ckb_pos.bcf
bcftools merge `ls *lifted.vcf.gz` -Ou | bcftools view -T ckb_chr_pos.chr.txt -Ob --threads 16 -Ob > sdgp.AllChr.ckb_pos.bcf

bcftools index hgdp_wgs.20190516.full.AllChr.ckb_pos.bcf
bcftools index 1kGP_high_coverage_Illumina.AllChr.filtered.SNV_INDEL_SV_phased_panel.ckb_pos.bcf
bcftools index sdgp.AllChr.ckb_pos.bcf

## We only need to keep the genotypes ##
bcftools annotate -x ^FORMAT/GT -Ob hgdp_wgs.20190516.full.AllChr.ckb_pos.bcf > hgdp_wgs.20190516.full.AllChr.ckb_pos.GTonly.bcf && bcftools index hgdp_wgs.20190516.full.AllChr.ckb_pos.GTonly.bcf
bcftools annotate -x ^FORMAT/GT -Ob sdgp.AllChr.ckb_pos.bcf > sdgp.AllChr.ckb_pos.GTonly.bcf && bcftools index sdgp.AllChr.ckb_pos.GTonly.bcf

## merge together SGDP, HGDP, 1KG into single file ##
bcftools merge sdgp.AllChr.ckb_pos.GTonly.bcf hgdp_wgs.20190516.full.AllChr.ckb_pos.GTonly.bcf 1kGP_high_coverage_Illumina.AllChr.filtered.SNV_INDEL_SV_phased_panel.ckb_pos.bcf -Ob > sgdp_hgdp_1kGP.AllChr.CKB_snps.GT.bcf

###### do some checks for relatedness ########

module purge all
module load PLINK/2.00a3.1-GCC-11.2.0

plink2 \
  --bcf sgdp_hgdp_1kGP.AllChr.CKB_snps.GT.bcf \
  --make-pfile \
  --out sgdp_hgdp_1kGP.AllChr.CKB_snps.GT

plink2 \
       --pfile sgdp_hgdp_1kGP.AllChr.CKB_snps.GT \
       --make-king-table \
       --king-table-filter 0.2 \
       --out sgdp_hgdp_1kGP.AllChr.CKB_snps.GT

### there's a few samples duplicated between the different datasets so we want to identify and remove them ###

sed '1d' sgdp_hgdp_1kGP.AllChr.CKB_snps.GT.kin0 | awk '{ if ($6 > 0.4) {print $1} }' > duplicates_remove.txt

plink2 \
  --pfile sgdp_hgdp_1kGP.AllChr.CKB_snps.GT \
  --remove duplicates_remove.txt \
  --make-pfile \
  --out sgdp_hgdp_1kGP.AllChr.CKB_snps.GT.no_duplicates

## turn back into VCF 

plink2 \
       --pfile sgdp_hgdp_1kGP.AllChr.CKB_snps.GT.no_duplicates \
       --recode vcf \
       --out sgdp_hgdp_1kGP.AllChr.CKB_snps.GT.no_duplicates

## bgzip now we have all the samples ready to merge with CKB and phase ##

module purge all
module load BCFtools/1.17-GCC-12.2.0

bgzip sgdp_hgdp_1kGP.AllChr.CKB_snps.GT.no_duplicates

