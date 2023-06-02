

cd ${mosaic_data}

Rscript ${programs}/MOSAIC/mosaic.R \
 --chromosomes 15:22 \
 --ancestries 2 \
 --panels "Korean Kyrgyz Tujia Thai Tu Burmese Uygur Mongolian Japanese Cambodian She DaiChinese Lezgin Yi KinhVietnamese" \
 --maxcores 4 \
 ${cluster} \
 ${mosaic_data}/

