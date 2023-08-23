#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J phaseHO
#SBATCH -o phaseHO_%A_%a.out
#SBATCH -e phaseHO_%A_%a.err
#SBATCH -p short
#SBATCH -c 16
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

beagle=${programs}/beagle.22Jul22.46e.jar
java -jar ${beagle} \
	gt=${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.vcf.gz \
	chrom=${chr} \
	map=${gen_maps}/plink.chr${chr}.GRCh38.map \
	nthreads=16 \
	out=${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased


