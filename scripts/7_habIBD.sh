#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J hap-ibd
#SBATCH -o hap-ibd_%j.out
#SBATCH -e hap-ibd_%j.err
#SBATCH -p short
#SBATCH --array 1-22
#SBATCH -c 3

chr=${SLURM_ARRAY_TASK_ID}
source ~/.bashrc

hap_IBD=hap-ibd.jar
programs=/well/ckb/users/aey472/projects/ckb_popgen/programs

external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/external_data
ckb_external_data=/well/ckb/users/aey472/projects/ckb_popgen/data/CKB_external
gen_maps=/well/ckb/users/aey472/projects/ckb_popgen/data/other_files/gen_maps
programs=/well/ckb/users/aey472/projects/ckb_popgen/programs
output=/well/ckb/users/aey472/projects/ckb_popgen/data/hap-ibd_output

module purge all && module load HTSlib/1.10.2-GCC-8.3.0

bgzip -d -c ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.bcf | gzip -c > ${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_sn
ps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.vcf.gz

java -jar ${programs}/${hap_IBD} \
	gt=${ckb_external_data}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.vcf.gz \
	map=${gen_maps}/plink.chr${chr}.GRCh38.map \
	out=${output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local

zcat ${output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.ibd.gz | cut -f1,3,8 | gzip -c > ${output}/sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.trimmed.ibd.gz
