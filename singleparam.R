perturbsinglep <- function(model_name, p_list, ep, norder, path_ptcut, path_p, order, ncores){

	require("parallel")
	moddir <- vector()
	sparams <- vector()
	eparams <- vector()
	
	ptbdir = paste(path_p, "db", sep = "")

	for (ele in 1:length(p_list)){
		outdir <- paste(ptbdir, "/", "k", toString(ele), "_", model_name, sep = "" )
		if (dir.exists(file.path(outdir))){
			system(paste('rm -r ', outdir, sep = "" ))
		}
	}
	

	system(paste('rm -r ', ptbdir, "/", "k*_", model_name, sep = "" ))

	for (pparam in p_list){
		mod = paste(pparam, "_", model_name, sep = "")
		system(paste('cp -r ', ptbdir, '/', model_name, "/ ", ptbdir, '/', mod, '/',sep = ""))
		moddir <- c(moddir, mod)
	}
	

	for (id in 1:length(p_list)){
		pparam = p_list[id]
		infile = file.path(paste(ptbdir, "/", pparam, "_", model_name, "/Params.txt", sep = ""))
		data <- readLines(infile)
		for (count in 1:length(data)){
			if (grepl(paste(pparam, " ", sep = ""),data[count])){
			 	x = data[count]}}

		x = gsub(pparam, ' ', x)
		x = gsub('=', ' ', x)
		x = as.numeric(x)
		
		start = x / (ep**norder)
		end = x/ (ep** -norder)
		sparams <- c(sparams, start)
		eparams <- c(eparams, end)
	}

	mclapply(1:length(p_list), function(x){
		system(paste('sage ', path_ptcut , ' ' ,  moddir[x]  ,' --ep ' , as.integer(ep),' --multiple-lpfiles ' , order,'  --stl --grid', ' ', p_list[x], ':', sparams[x],':', eparams[x], ':*', ep,  sep = ""))
	}, mc.cores = ncores)	  		

	
}
