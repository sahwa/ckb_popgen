#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J chromopainter
#SBATCH -o chromopainter_%A_%a.out
#SBATCH -e chromopainter_%A_%a.err
#SBATCH -p short
#SBATCH --array 1-100
#SBATCH -c 1

#$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' CKB_indexes.txt)
source ~/.bashrc
source directories.config

##### convert to CP format #####
chr=${SLURM_ARRAY_TASK_ID}

echo $chr

stem=sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local
vcf2cp=/well/ckb/users/aey472/projects/ckb_popgen/programs/vcf_to_chromopainter/src/vcf_to_chromopainter_main.R
vcf_input=${ckb_external_data}/${stem}.vcf.gz

#Rscript ${vcf2cp} \
#	-g ${vcf_input} \
#	-u FALSE \
#	-o ${chromopainter_dir}/${stem}

#sed -i '4,$s/ //g' ${chromopainter_dir}/${stem}.chromopainter.inp

#perl ${programs}/make_recomfile.pl \
#	-M plink \
#	${chromopainter_dir}/${stem}.chromopainter.inp  \
#	${genmaps}/plink.chr${chr}.GRCh38.map \
#	${chromopainter_dir}/${stem}.recomrates.txt

line=$(sed -n ${SLURM_ARRAY_TASK_ID}'{p;q}' batches_chrs.txt)
chr=$(echo $line | cut -d' ' -f1)
stem=sgdp_hgdp_1kGP_CKB.chr${chr}.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local
batch=$(echo $line | cut -d' ' -f 2)

${programs}/ChromoPainterV2/ChromoPainterv2 \
	-g ${chromopainter_dir}/${stem}.chromopainter.inp \
	-r ${chromopainter_dir}/${stem}.recomrates.txt \
	-f ${chromopainter_dir}/CKB_inds_batch${batch}.popfile.txt 0 0 \
	-t ${chromopainter_dir}/sgdp_hgdp_1kGP_CKB.chr22.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.idfile.txt \
	-o ${chromopainter_dir}/${stem}.batch_${batch} \
	-s 10



