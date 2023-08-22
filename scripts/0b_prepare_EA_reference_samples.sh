#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J 1kg
#SBATCH -o 1kg_%A_%a.out
#SBATCH -e 1kg_%A_%a.err
#SBATCH -p short
#SBATCH -c 1
#SBATCH -a 1-22

chr=${SLURM_ARRAY_TASK_ID}
#source ~/.bashrc
source directories.config

ho=/well/ckb/users/aey472/projects/tskit/data/snp_comparison/Axiom_GW_HuOrigin.na35.lifted.bed
oneKG=/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/1000Genomes

## extract only positions present in CKB ##

#module purge all
#module load BCFtools/1.17-GCC-12.2.0
#cd /well/ckb/users/aey472/projects/tskit/data/snp_comparison

#bcftools view -v snps -M 2 -m 2 -r chr${chr} -Ou 1kGP_high_coverage_Illumina.AllChr.filtered.SNV_INDEL_SV_phased_panel.bcf | bcftools view -T Axiom_GW_HuOrigin.na35.chr${chr}.lifted.bed -Oz > ${oneKG}/1kGP_high_coverage_Illumina.AllChr.filtered.SNV_INDEL_SV_phased_panel.HumanOrigins.chr${chr}.vcf.gz

conform=${programs}/conform-gt.24May16.cee.jar
## important - need to make sure the alleles are on the same strand with CKB or else we can't merge ###
#java -jar -Xmx8g ${conform} \
#       gt=${oneKG}/1kGP_high_coverage_Illumina.AllChr.filtered.SNV_INDEL_SV_phased_panel.HumanOrigins.chr${chr}.vcf.gz \
#       ref=../data/HumanOriginsExternal/merge/chr${chr}.cdefg.WBKG.GRCh38.HumanOrigins.dose.vcf.gz \
#       match=POS \
#       chrom=chr${chr} \
#       out=${oneKG}/1kGP_high_coverage_Illumina.AllChr.filtered.SNV_INDEL_SV_phased_panel.HumanOrigins.chr${chr}.conformed \
#       strict=true

tabix -f ${oneKG}/1kGP_high_coverage_Illumina.AllChr.filtered.SNV_INDEL_SV_phased_panel.HumanOrigins.chr${chr}.conformed.vcf.gz
bcftools view ${oneKG}/1kGP_high_coverage_Illumina.AllChr.filtered.SNV_INDEL_SV_phased_panel.HumanOrigins.chr${chr}.conformed.vcf.gz -Ob > ${oneKG}/1kGP_high_coverage_Illumina.AllChr.filtered.SNV_INDEL_SV_phased_panel.HumanOrigins.chr${chr}.conformed.bgz.vcf.gz
bcftools index -f ${oneKG}/1kGP_high_coverage_Illumina.AllChr.filtered.SNV_INDEL_SV_phased_panel.HumanOrigins.chr${chr}.conformed.bgz.vcf.gz 
