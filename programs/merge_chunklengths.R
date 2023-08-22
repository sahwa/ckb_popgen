library(data.table)
library(optparse)
library(stringr)

option_list = list(
  make_option(c("-p", "--pre_chr"),
    type="character",
    default=NULL,
    help="name of file before chr",
    metavar="character"),
  make_option(c("-a", "--post_chr"),
    type="character",
		default=NULL,
    help="name of file after chr",
    metavar="character"),
  make_option(c("-c", "--chrs"),
    type="character",
		default=NULL,
    help="comma separated list of chrs to analyse",
    metavar="logical"),
  make_option(c("-o", "--output"),
    type="character",
    default=NULL,
    help="Output file path. no default - required",
    metavar="character"),
  make_option(c("-n", "--names"),
    type="character",
    default=NULL,
    help="list of sample names for output",
    metavar="character"),
	make_option(c("-x", "--pca"),
		type="character",
		default="false",
		help="perform PCA on the matrix",
		metavar="character")
  )

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

setDTthreads(0L)
getDTthreads()

### parse args ###
names = fread(opt$names, header=F)$V1
chrs = strsplit(opt$chrs, ",")[[1]]

for (i in chrs) {

	print(i)

	current = fread(
			paste0(opt$pre_chr, i, opt$post_chr),
			header=T
			)

	current[, RECIPIENT := NULL]

	if (i == chrs[1]) {
		total = as.data.table(matrix(0, nrow=nrow(current), ncol=ncol(current)))
		colnames(total) = colnames(current)
	}

	total = total + current
}

total[, RECIPIENT := names]
setcolorder(total, c("RECIPIENT", colnames(total)[-ncol(total)]))
colnames(total)[-1] = names

if (opt$pca == "TRUE") {
	pca = data.table(inds = total$RECIPIENT, irlba::prcomp_irlba(total[,-1], n=20)$x)
	
	if (str_detect(opt$out, ".gz")) outname = paste0(paste0(rev(rev(str_split(opt$out, "\\.")[[1]])[-c(1:3)]), collapse="."), ".pca.gz", collapse=".")
	if (!str_detect(opt$out, ".gz")) outname = paste0(paste0(rev(rev(str_split(opt$out, "\\.")[[1]])[-c(1:2)]), collapse="."), ".pca.gz", collapse=".")
	
	fwrite(pca, outname) 
}

fwrite(total, opt$output, col.names=T, sep=" ", verbose=T, quote=F)
