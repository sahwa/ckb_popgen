#!/usr/bin/env Rscript
library(data.table)

args = commandArgs(trailingOnly=TRUE)

library(MOSAIC)

setwd("/well/ckb/users/aey472/projects/ckb_popgen/data/MOSAIC/MOSAIC_RESULTS")

pop = args[1]
invisible(sapply(list.files(pattern="RData")[grep(pop, list.files(pattern="RData"))], load, .GlobalEnv))

bs = bootstrap_individuals_coanc_curves(acoancs,dr,alpha)
quantile = quantile(sapply(bs$boot.gens, function(x) x[1,2]), prob=c(0.025,0.975))

res = data.table(quantile = names(quantile), gens = quantile, pop = pop)
pop = stringr::str_replace_all(pop, ";", "_")

fwrite(res, paste0(pop, "_mosaic_bootstraps.txt"), col.names=T, sep=" ")
