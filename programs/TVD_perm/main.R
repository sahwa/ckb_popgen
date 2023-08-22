#!/usr/bin/env Rscript
args = commandArgs(trailingOnly = TRUE)

library(data.table)
library(dplyr)
library(stringr)
library(tidyr)

batch = basename(args[1]) %>% str_remove_all("TVD_batch_|\\.txt")

setDTthreads(0L)

Rcpp::sourceCpp("/well/ckb/users/aey472/projects/ckb_popgen/programs/TVD_perm/src.cpp")
chunklengths = fread("/well/ckb/users/aey472/projects/ckb_popgen/data/painting_output/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.5000_PC_midpoints.chunklengths.out.merged_cols.gz", verbose=T)

recipients = chunklengths$RECIPIENT
chunklengths[, RECIPIENT := NULL]

chunklengths = as.matrix(chunklengths)
rowSums_div_val = mean(unique(rowSums(chunklengths)))

chunklengths = data.table(RECIPIENT = recipients, chunklengths / rowSums_div_val)

idfile = fread("/well/ckb/users/aey472/projects/ckb_popgen/data/finestructure_output/fs_greedy_subset/sgdp_hgdp_1kGP_CKB.AllChr.AllChr.CKB_snps.GT.no_duplicates.rmdup.conformed.phased.newnames.maf_filter.relfree.local.5000_PC_midpoints.popdf.txt", header=F) %>%
	mutate(V2 = str_remove_all(V2, "x_"))

pops = unique(idfile$V2)

n_iterations = 100 * 1000

total_res = list()
total_counter = 0

combinations = fread(args[1])

for (j in 1:nrow(combinations)) {

	total_counter = total_counter + 1
	print(j)

	pop_a = combinations$Var1[j]
	pop_b = combinations$Var2[j]
	
	inds_a = idfile[V2 == pop_a]$V1
	inds_b = idfile[V2 == pop_b]$V1

	subset_a = chunklengths[RECIPIENT %in% inds_a, -1]
	subset_b = chunklengths[RECIPIENT %in% inds_b, -1]

	smaller_n = min(length(inds_a), length(inds_b))
	a_b_res = list()

	counter1 = 0

	for (i in 1:n_iterations) {

		counter1 = counter1 + 1
		if (i %% 1000 == 0) print(i)

		subset_a_tmp = subset_a[sample(smaller_n)]
		subset_b_tmp = subset_b[sample(smaller_n)]

		a_tvd = TVD_cpp_gpt(as.matrix(subset_a_tmp))
		b_tvd = TVD_cpp_gpt(as.matrix(subset_b_tmp))

		upper_pop = sample(c("subset_a_tmp", "subset_b_tmp"), 1)

		lower_pop = c("subset_a_tmp", "subset_b_tmp")[!c("subset_a_tmp", "subset_b_tmp") == upper_pop]

		c_dat = rbindlist(list(get(upper_pop)[sample(floor(smaller_n / 2))], get(lower_pop)[sample(ceiling(smaller_n / 2))]))
		c_tvd = TVD_cpp_gpt(as.matrix(c_dat))

		## true if null 
		a_b_res[[counter1]] = list(a_tvd = c_tvd < a_tvd, b_tvd = c_tvd < b_tvd)
	}

	a = do.call(rbind.data.frame, a_b_res) 

	total_res[[total_counter]] = list(a = sum(a$a_tvd) / n_iterations, b = sum(a$b_tvd) / n_iterations, pop_a = pop_a, pop_b = pop_b)

}

total_res = do.call(rbind.data.frame, total_res)
fwrite(total_res, paste0("/well/ckb/users/aey472/projects/ckb_popgen/data/TVD_test/perm_test_res.",batch,".txt"))
