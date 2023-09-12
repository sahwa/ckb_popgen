#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J phaseHO
#SBATCH -o phaseHO_%A_%a.out
#SBATCH -e phaseHO_%A_%a.err
#SBATCH -p short
#SBATCH -c 32
#SBATCH -a 1-22%7

source directories.config
source ~/.bashrc

oneKG=/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/1000Genomes

chr=${SLURM_ARRAY_TASK_ID}
merge_dir=/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/merge/

#module purge all && module load BCFtools/1.17-GCC-12.2.0

#bcftools annotate -Ob --rename-chrs rename_chrs.txt ../data/HumanOriginsExternal/merge/chr${chr}.cdefg.WBKG.GRCh38.HumanOrigins.dose.vcf.gz > ${chr}_ckb_tmp && mv ${chr}_ckb_tmp ../data/HumanOriginsExternal/merge/chr${chr}.cdefg.WBKG.GRCh38.HumanOrigins.dose.vcf.gz
#bcftools index ../data/HumanOriginsExternal/merge/chr${chr}.cdefg.WBKG.GRCh38.HumanOrigins.dose.vcf.gz

#bcftools annotate -Ob --rename-chrs rename_chrs.txt ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.vcf.gz > ${chr}_ext_tmp && mv ${chr}_ext_tmp ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.vcf.gz
#bcftools index ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.vcf.gz 

#bcftools merge \
#	../data/HumanOriginsExternal/merge/chr${chr}.cdefg.WBKG.GRCh38.HumanOrigins.dose.vcf.gz \
#	${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.vcf.gz | \
#sed 's/|/\//g' | \
#bcftools view -Oz > ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.vcf.gz

beagle=/well/ckb/users/aey472/projects/ckb_popgen/programs/beagle.22Jul22.46e.jar

#java -Xmx32g -jar ${beagle} \
#	gt=${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.vcf.gz \
#	chrom=chr${chr} \
#	out=${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased \
#	nthreads=24 \
#	gp=true \
#	map=${genmaps}/plink.chr${chr}.GRCh38.map

#module purge all && module load BCFtools/1.17-GCC-12.2.0
#bcftools view -Ob ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.vcf.gz > ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.bgz.vcf.gz
#bcftools index ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.bgz.vcf.gz

#module purge all && module load SHAPEIT4/4.2.2-foss-2021a
#shapeit4.2 \
#	--input ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.bgz.vcf.gz \
#	--out ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.bgz.vcf.gz \
#	--region chr${chr} \
#	--thread 40 \
#	--map	/well/ckb/users/aey472/program_files/shapeit4/maps/chr${chr}.b37.gmap.gz

###### get missing #######

#£module purge all && module load PLINK/2.00a3.1-GCC-11.2.0
#plink2 \
#	--vcf ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.vcf.gz \
#	--missing \
#	--freq	\
#	--out ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB 

#module purge all && module load BCFtools/1.17-GCC-12.2.0
#tabix -f ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.vcf.gz
#bcftools reheader -s ${merge_dir}/newnames_samples.txt ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.vcf.gz > ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.bgz.vcf.gz

#tabix -f ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.bgz.vcf.gz

#bcftools view --force-samples -S ${merge_dir}/keep_painting_samples.txt -Ob ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.bgz.vcf.gz > ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.bgz.vcf.gz

#module purge all && module load PLINK/2.00a3.1-GCC-11.2.0
#plink2 \
#	--bcf ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.bgz.vcf.gz \
#	--maf 0.01 \
#	--geno 0.001 \
#	--export bgz vcf \
#	--out ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.maf_filter

## make final list of samples to keep (remove outliers and PCA dupes etc) ##
#cat relfree_local.txt ext_painting_samples_keep.txt > ext_painting_samples_keep.relfree_local.txt
#bcftools reheader -s vcf_newnames_sep11.txt ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.maf_filter.vcf.gz > ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.maf_filter.final_names.vcf.gz

conda activate pbwt
pbwt \
	-readVcfGT ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.maf_filter.final_names.vcf.gz \
	-selectSamples ext_painting_samples_keep.relfree_local.txt \
	-check \
	-stats \
	-paint ${painting_output}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.maf_filter.final_names

gzip -f ${painting_output}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.maf_filter.final_names.chunkcounts.out
gzip -f ${painting_output}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_AllChr.missing_filtered.remove_related_duplicates.chr${chr}.CKB.phased.newnames.relfree.local.moderns.maf_filter.final_names.chunklengths.out

#Rscript ${programs}/merge_chunklengths.R \
#  -n ${sample_names} \
#  -p "sgdp_hgdp_1kGP_CKB.chr" \
#  -a ".AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.chunklengths.out.gz" \
#  -c "1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" \
#  -o "sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.all_CKB_external.chunklengths.out.gz"
