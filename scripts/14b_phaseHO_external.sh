#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J phaseHO
#SBATCH -o phaseHO_%A_%a.out
#SBATCH -e phaseHO_%A_%a.err
#SBATCH -p short
#SBATCH -c 24
#SBATCH -a 1-22%5

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

#beagle=/well/ckb/users/aey472/projects/ckb_popgen/programs/beagle.22Jul22.46e.jar

#java -Xmx32g -jar ${beagle} \
#	gt=${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.vcf.gz \
#	chrom=${chr} \
#	out=${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased \
#	nthreads=64 \
#	gp=true \
#	map=${genmaps}/plink.chr${chr}.GRCh38.map

#module purge all && module load BCFtools/1.17-GCC-12.2.0

#tabix -f ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.vcf.gz
#bcftools reheader -s ${merge_dir}/newnames_samples.txt ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.vcf.gz > ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.bgz.vcf.gz

#tabix -f ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.bgz.vcf.gz

#bcftools view --force-samples -S ${merge_dir}/keep_painting_samples.txt -Ob ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.bgz.vcf.gz > ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.bgz.vcf.gz

#invcf=${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.bgz.vcf.gz
#outfile=${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.gprobsmetrics.txt

#bcftools view ${invcf} | java -jar ${programs}/vcf2gprobs.jar | java -jar ${programs}/gprobsmetrics.jar > ${outfile}

#bcftools view -G ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.bgz.vcf.gz | grep -v '##' | cut -f8 > ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.maf.txt 

module purge all && module load PLINK/2.00a3.1-GCC-11.2.0
plink2 \
	--bcf ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.bgz.vcf.gz \
	--maf 0.02 \
	--export bgz vcf \
	--out ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.maf_filter

conda activate pbwt 
pbwt \
	-readVcfGT ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.maf_filter.vcf.gz \
	-check \
	-stats \
	-paint ${painting_output}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.maf_filter

#rm ${painting_output}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.maf_filter.regionsquaredchunkcounts.out
#rm ${painting_output}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.maf_filter.regionchunkcounts.out

#gzip -f ${painting_output}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.maf_filter.chunkcounts.out
#gzip -f ${painting_output}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.maf_filter.chunklengths.out
