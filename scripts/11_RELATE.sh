#!/bin/bash
#SBATCH -A ckb.prj
#SBATCH -J TVD_perm
#SBATCH -o TVD_perm_%A_%a.out
#SBATCH -e TVD_perm_%A_%a.err
#SBATCH -p short
#SBATCH -c 1
#SBATCH -a 1-22

source directories.config
source ~/.bashrc

clusters_regex="211Qingdao|268Liuzhou"
qctool=/well/ckb-share/local/bin/qctool2
bgen=/well/ckb/shared/filesystem/genetic_data/CKB_imputed/v2.0_b38


### merge topmed imputed data ###

${qctool} -g ${bgen}/CKB_imputed_v2_b38_chr${chr}.bgen -ofiletype vcf -



${programs}/RELATE/bin/Relate \
  --mode All \
  -m 1.25e-8 \
  -N 30000 \
  --haps data/example.haps \
  --sample data/example.sample \
  --map data/genetic_map.txt \
  --annot data/example.annot \
  --seed 1 \
  -o example
