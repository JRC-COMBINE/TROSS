tolp <- function(path_p, model_name, p_list, ep, norder){

	outdir = paste(path_p, "db/", sep = "")
	mods <- numeric()
	options(digits = 0, scipen = -10)


	for (pparam in p_list){
		mods<- c(mods, paste(pparam, "_", model_name, sep = ""))
	}

	for (mod in mods){
		
		eps = toString(as.integer(ep))
		data <- readLines(file.path(outdir, paste(mod, "/ep", eps, "-log.txt", sep = "")))
	
		# extract k-values, remove arbitrary strings
		fname <- data[grepl("Grid point: ",data)]
		fname <-gsub("Grid point: ", "", fname)
		temp <- gsub(" = ","_", fname)
	 	param = gsub("_.*", "", temp)
	    linenum = as.integer(substring(param, 2))
	    val = paste(param, "=", gsub(".*_", "", temp))

		# extract start and end strings from log file
		x1 <- grep("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ file 0", data)
		x2 <- grep("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ end", data)
		n = as.list(c(1: length(x1)))
		p = lapply(n, function(y) return(c(x1[y],x2[y])))
		r = list()

		# create output list of lists
		out <- lapply(p, function(x) return(data[x[1]:x[2]]))
		param <- sub('_.*','', temp)[1]
		r <- seq(-norder, norder, by=1)
		r <- sub('e.*', '', r)

	# extract the solutions and write to lp files
	for (j in 1:length(out)){
		data <- out[[j]]
		ids <- which(!nzchar(data))
		x <- matrix(ids,nrow = 2,ncol = length(ids)/2)
		x <- matrix(ids,nrow = 2,ncol = length(ids)/2)
		n = as.list(c(1: as.integer(length(x)/2)))
		p = lapply(n, function(y)c(x[1,][y],x[2,][y]))
		q <- lapply(p, function(x) return(data[x[1]:x[2]]))
		dir <- paste(param, "_gamma_",r[[j]], "_", model_name ,sep="" )
		dir.create(file.path(outdir, paste(mod, "/", dir, sep = "")), showWarnings = FALSE)
		system(paste('cp ', outdir, mod, "/Params.txt ", outdir, mod, "/", dir, sep = "" ))
		parfile = readLines(paste(outdir, mod, "/", dir, "/Params.txt", sep = ""))
		parfile[linenum]= val[j]
		writeLines(parfile,paste(outdir, mod, "/", dir, "/Params.txt", sep = ""))

		for (i in 1:length(q)){
			names <-paste("ep", eps, "-sol-0000", as.integer(i-1), sep="")
			outname <- paste(names, ".lp", sep= "")
			write.table(q[[i]], paste(outdir, mod, "/", dir, "/",outname, sep = ""), col.names= F, row.names= F, quote= F)
	}
	}}


}

