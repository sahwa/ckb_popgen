#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J extractHO
#SBATCH -o extractHO_%A_%a.out
#SBATCH -e extractHO_%A_%a.err
#SBATCH -p short
#SBATCH -c 3
#SBATCH -a 10

source directories.config
source ~/.bashrc

stuff=/well/ckb/users/aey472/projects/cadd_imputation/pop_subset_AFs
oneKG=/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/1000Genomes

#chr=${SLURM_ARRAY_TASK_ID}

#module purge all

#ls -d ../data/HumanOriginsExternal/* | grep -v 'tar' > HumanOriginsExtDirs.txt

file=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' HumanOriginsExtDirs.txt)
bname=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' HumanOriginsBasenames.txt)

## convert all the EIGENSTRAT data to VCF 

#python2.7 $programs/gdc/eigenstrat2vcf.py -r ${file}/${bname} > ${file}/${bname}.vcf
module purge all && module load HTSlib/1.17-GCC-12.2.0
bgzip ${file}/${bname}.vcf
tabix ${file}/${bname}.vcf.gz

## do the stuff necessary for liftover ##

module purge all && module load BCFtools/1.17-GCC-12.2.0
bcftools annotate --rename-chrs rename_chrs.txt ${file}/${bname}.vcf.gz -Oz > ${file}/${bname}.rename_chrs.vcf.gz
bcftools index ${file}/${bname}.rename_chrs.vcf.gz

module purge all && module load PLINK/2.00a3.1-GCC-11.2.0
plink2 \
	--vcf ${file}/${bname}.rename_chrs.vcf.gz \
	--snps-only 'just-acgt' \
	--chr 1-22 \
	--recode vcf bgz \
	--out ${file}/${bname}.rename_chrs.actg

module purge all && module load BCFtools/1.17-GCC-12.2.0
bcftools annotate --rename-chrs rename_chrs.txt ${file}/${bname}.rename_chrs.actg.vcf.gz -Oz > ${file}/${bname}.rename_chrs.actg.rename_chrs.vcf.gz
bcftools index ${file}/${bname}.rename_chrs.actg.rename_chrs.vcf.gz

module purge all && module load picard/3.0.0-Java-17
java -jar -Xmx32g $EBROOTPICARD/picard.jar LiftoverVcf \
	I=${file}/${bname}.rename_chrs.actg.rename_chrs.vcf.gz \
	O=${file}/${bname}.lifted.rename_chrs.actg.rename_chrs.vcf.gz \
	CHAIN=${stuff}/hg19ToHg38.over.chain \
	REJECT=${file}/${bname}.rejected.rename_chrs.actg.rename_chrs.vcf.gz \
	R=${stuff}/Homo_sapiens_assembly38.fasta \
	RECOVER_SWAPPED_REF_ALT=true \
	MAX_RECORDS_IN_RAM=5000

module purge all && module load BCFtools/1.17-GCC-12.2.0

£bcftools norm --rm-dup snps ${file}/${bname}.lifted.rename_chrs.actg.rename_chrs.vcf.gz | bcftools view -M 2 -Ob > ${file}/${bname}.lifted.rename_chrs.actg.rename_chrs.rmdup.vcf.gz
bcftools index ${file}/${bname}.lifted.rename_chrs.actg.rename_chrs.rmdup.vcf.gz

for (( i = 1; i <= 22; i++ )); do
	bcftools view -e"ALT=='.'" -r chr${i} ${file}/${bname}.lifted.rename_chrs.actg.rename_chrs.rmdup.vcf.gz -Oz > ${file}/${bname}.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${i}.vcf.gz
done

#module purge all && module load PLINK/2.00a3.1-GCC-11.2.0
#plink2 --pfile ${ho_ckb_subset}/CKB_imputed_v2_b38_chr${chr} --recode vcf bgz --out ${ho_ckb_subset}/CKB_imputed_v2_b38_chr${chr}
#module purge all && module load BCFtools/1.17-GCC-12.2.0
#bcftools annotate --rename-chrs rename_chrs.txt ${ho_ckb_subset}/CKB_imputed_v2_b38_chr${chr}.vcf.gz -Oz > ${ho_ckb_subset}/CKB_imputed_v2_b38_chr${chr}.rename_chrs.vcf.gz

#line=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' HumanOriginsBasenames_chr.txt)
#bname=$(echo $line | cut -d' ' -f1)
#chr=$(echo $line | cut -d' ' -f3)
#file=$(echo $line | cut -d' ' -f2)

#mv ../data/HumanOriginsExternal/merge/chr${chr}.cdefg.WBKG.GRCh38.HumanOrigins.dose.vcf.gz ../data/HumanOriginsExternal/merge/chr${chr}.cdefg.WBKG.GRCh38.HumanOrigins.dose.bgz.vcf.gz
#bcftools view -Oz ../data/HumanOriginsExternal/merge/chr${chr}.cdefg.WBKG.GRCh38.HumanOrigins.dose.bgz.vcf.gz > ../data/HumanOriginsExternal/merge/chr${chr}.cdefg.WBKG.GRCh38.HumanOrigins.dose.vcf.gz 

conform=${programs}/conform-gt.24May16.cee.jar
## important - need to make sure the alleles are on the same strand with CKB or else we can't merge ###
#java -jar -Xmx8g ${conform} \
#	gt=${file}/${bname}.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${chr}.vcf.gz \
#	ref=../data/HumanOriginsExternal/merge/chr${chr}.cdefg.WBKG.GRCh38.HumanOrigins.dose.vcf.gz \
#	match=POS \
#	chrom=chr${chr} \
#	out=${file}/${bname}.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${chr}.conformed \
#	strict=true

#module purge all && module load BCFtools/1.17-GCC-12.2.0
#tabix -f ${file}/${bname}.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${chr}.conformed.vcf.gz
#bcftools view ${file}/${bname}.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${chr}.conformed.vcf.gz -Ob > ${file}/${bname}.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${chr}.conformed.bgz.vcf.gz
#bcftools index -f ${file}/${bname}.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${chr}.conformed.bgz.vcf.gz


#bcftools merge \
#	--force-samples \
#	-Ob \
#	/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/EastAsianAncientWang/EastAsian_166ancientgenomes_public.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${chr}.conformed.bgz.vcf.gz \
#	/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/Lao_individuals_2023/Lao_individuals.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${chr}.conformed.bgz.vcf.gz \
#	/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/LipsonModern2018/SEA2.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${chr}.conformed.bgz.vcf.gz \
#	/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/Nakatskua_FilteredData/IndiaHO_dataforrelease.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${chr}.conformed.bgz.vcf.gz \
#	/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/QinStoneking/QinStoneking2015.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${chr}.conformed.bgz.vcf.gz \
#	/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/SkoglundPacific/SkoglundEtAl2016_Pacific_FullyPublic.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${chr}.conformed.bgz.vcf.gz \
#	/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/WangModern/EastAsian_HO.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${chr}.conformed.bgz.vcf.gz \
#	/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/Kutanan_Liu_2021_Thai_Lao/Kutanan_Liu_2021_Thai_Lao.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${chr}.conformed.bgz.vcf.gz \
# /well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/Viet_Liu_2020/Viet_Liu_2020.lifted.rename_chrs.actg.rename_chrs.rmdup.chr${chr}.conformed.bgz.vcf.gz \
# ${oneKG}/1kGP_high_coverage_Illumina.AllChr.filtered.SNV_INDEL_SV_phased_panel.HumanOrigins.chr${chr}.conformed.bgz.vcf.gz |
#bcftools reheader -s /well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/merge/newnames.txt > /well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/merge/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_1KG_chr${chr}.vcf.gz 

#merge_dir=/well/ckb/users/aey472/projects/ckb_popgen/data/HumanOriginsExternal/merge/

#bcftools concat `ls ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_Kutanan_Viet_chr{7..22}.vcf.gz`

#plink2 \
#	--bcf ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_AllChr.vcf.gz \
#	--maf 0.01 \
#	--indep-pairwise 50 5 0.2 \
#	--out ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_AllChr

#plink2 \
#	--bcf ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_AllChr.vcf.gz \
#	--extract ${merge_dir}/WangAncient_Lao_Lipson_Nakatskua_QinSt_Skoglund_WangModern_AllChr.prune.in \
#	--pca










