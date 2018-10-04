#
# Copyright 2018-2019 
# Authors: Satya Swarup Samal, Jeyashree Krishnan
#
# TROSS is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# TROSS is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public License
# along with TROSS.  If not, see <http://www.gnu.org/licenses/>.
#
# logtolp post-processor
# Reads in the log file from ptcut and outputs .lp files
#
tolp <- function(path_p, model_name, p_list, ep){

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

		# create output list of lists
		out <- lapply(p, function(x) return(data[x[1]:x[2]]))
		x <- sub('.*_', '', temp)
		param <- sub('_.*','', temp)[1]
		x <- as.double(unlist(strsplit(x,",")))
		mid = as.integer(length(x)/2)
		y <- x/ x[mid]
		y <- sub('.*e', '', y)
		y <- sub('0', '', y)
		y <- sub("+", "", y, fixed = TRUE)
		y <- as.integer(y)
		r = list()

		for (ele in 1:length(y)){
			if (y[[ele]] <0){
				r <- c(r, y[[ele]])
			}
			else if ((y[[ele]]) >= 0){
				y[[ele]] <- y[[ele]]-1
				r <- c(r, y[[ele]])
			}
		}

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

