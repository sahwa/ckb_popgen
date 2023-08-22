#!/usr/env/bin/Rscript

library(optparse)
library(stringr)
library(data.table)

option_list = list(
	optparse::make_option(c("-c", "--chunklengths"), 
		type="character", 
		default=NULL, 
		help="genotype file name. no default - required", 
		metavar="character"), 
	optparse::make_option(c("-p", "--popfile"), 
		type="character", 
		help="genotype likelihoods file name", 
		metavar="character"), 
	optparse::make_option(c("-o", "--output"), 
		type="character", 
		default=NULL, 
		help="Output file path. no default - required", 
		metavar="character")
    )

opt_parser = optparse::OptionParser(option_list=option_list);
opt = optparse::parse_args(opt_parser);

if (is.null(opt$popfile)) stop("need popfile")
if (is.null(opt$chunklengths)) stop("need chunklengths")
if (is.null(opt$output)) stop("need output")

popfile = fread(opt$popfile, header=F)
chunklengths = fread(opt$chunklengths, verbose=T, header=T)

pops = unique(popfile$V2)

ckb_pops = c("Harbin", "Gansu", "Hunan", "Henan", "Liuzhou", "Zhejiang",
"Haikou", "Sichuan", "Qingdao", "Suzhou")

ext_inds = colnames(chunklengths)[-1][!str_detect(colnames(chunklengths)[-1], paste0(ckb_pops, collapse="|"))]
ext_inds_dt = data.table(V1 = ext_inds, V2 = str_remove_all(ext_inds, "[0-9]"))
ext_inds_pops = unique(str_remove_all(ext_inds, "[0-9]"))

non_cluster_inds = colnames(chunklengths)[-1][!colnames(chunklengths)[-1] %in% c(popfile$V1, ext_inds)]
non_cluster_inds_dat =data.table(V1 = non_cluster_inds, V2 = str_remove_all(non_cluster_inds, "[0-9]"))

keyfile = rbind(non_cluster_inds_dat, ext_inds_dt, popfile)
newcolnames = c("RECIPIENT", keyfile$V2[match(colnames(chunklengths)[-1], keyfile$V1)])
setnames(chunklengths, newcolnames)
chunklengths[, RECIPIENT := newcolnames[-1]]

all_pops = c(pops, ckb_pops, ext_inds_pops)
all_pops = all_pops[all_pops %in% chunklengths$RECIPIENT]

print(paste0("Processing: ", all_pops))


res_dt = rbindlist(lapply(seq_along(all_pops), function(x) {
	chunklengths[RECIPIENT == all_pops[x]][,
		melt(.SD, id.vars="RECIPIENT")][,
			list(value = mean(value)), by=c("RECIPIENT", "variable")][,
				dcast(.SD, RECIPIENT~variable)]
		}
	)
)

fwrite(res_dt, opt$output, sep=" ", col.names=T, row.names=F)
