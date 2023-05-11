#!/usr/bin/env Rscript
library(data.table)

args = commandArgs(trailingOnly=TRUE)

#### adapted from Dan Lawson's FS library scripts

suppressPackageStartupMessages(library(dendextend))

source("/well/ckb/users/aey472/projects/ckb_popgen/programs/FinestructureLibrary.R")

treefile = args[1]

treexml = xmlTreeParse(treefile) 
ttree = extractTree(treexml) 

ttree$node.label = NULL
ttree$node.label[ttree$node.label=="1"]  = ""
ttree$node.label[ttree$node.label!=""]  = format(as.numeric(ttree$node.label[ttree$node.label!=""]),digits=2)

ttree$node.label = NULL

nodelab = ttree$node.label
ttree$node.label = NULL
htree = my.as.hclust.phylo(ttree,0.01)
dend = as.dendrogram(htree)
if(!is.null(nodelab))dend = setNodeLabels(dend,nodelab)
tdend = dend

mapstate = extractValue(treexml,"Pop") 
mapstatelist = popAsList(mapstate) 

popnames = lapply(mapstatelist,NameSummary) 
popnamesplot = lapply(mapstatelist,NameMoreSummary) 
names(popnames) = popnamesplot 
names(popnamesplot) = popnamesplot 
names(mapstatelist) =  names(popnames)

clusternames_df = rbindlist(lapply(seq_along(mapstatelist), function(x) {
	data.table(mapstatelist[[x]])[, clustername := names(popnames)[x]]
	})
)

clusternames_df[, clustername := paste0("x_", clustername)]

fwrite(clusternames_df, args[2], col.names=F, sep=" ")
