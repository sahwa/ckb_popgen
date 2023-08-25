#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J phaseHO
#SBATCH -o phaseHO_%A_%a.out
#SBATCH -e phaseHO_%A_%a.err
#SBATCH -p short
#SBATCH -c 32
#SBATCH -a 1-22

source directories.config
source ~/.bashrc

oneKG=/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/1000Genomes

chr=${SLURM_ARRAY_TASK_ID}
merge_dir=/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/merge/

#module purge all && module load BCFtools/1.17-GCC-12.2.0
#bcftools index -f ../data/HumanOriginsExternal/merge/chr${chr}.cdefg.WBKG.GRCh38.HumanOrigins.dose.vcf.gz
#bcftools merge \
#	../data/HumanOriginsExternal/merge/chr${chr}.cdefg.WBKG.GRCh38.HumanOrigins.dose.vcf.gz \
#	${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.vcf.gz | \
#sed 's/|/\//g' | \
#bcftools view -Oz > ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.vcf.gz

module purge all && module load BCFtools/1.17-GCC-12.2.0
zcat ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.vcf.gz | bgzip -c > ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.bgz.vcf.gz
bcftools index -f ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.bgz.vcf.gz

gmap=/well/ckb/users/aey472/program_files/shapeit4/maps/chr${chr}.b38.gmap.gz

module purge all && module load SHAPEIT4/4.2.2-foss-2020b
shapeit4.2 \
	--input ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.bgz.vcf.gz \
	--region ${chr} \
	--map ${gmap} \
	--thread 32 \
	--out ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased


