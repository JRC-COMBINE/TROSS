samplePoints = function(file,n,num_var, BB, ini_vals, ep, lb_v, ub_v){
  res <- readLines(file)
  E = matrix(ncol = num_var)
  G = matrix(ncol = num_var)
  F = c()
  H = c()
  d = c()
  for(lin in res){
    if(grepl("ie", lin) || grepl("eq", lin)){
      r = rep(0,num_var)
      s = strsplit(lin, " ")[[1]]
      if(length(which(s=="\\"))> 0 )
        s = s[-seq(from = which(s=="\\"), to = length(s))]
      pos = grep("x",s)
      coeff = s[pos-1]
      coeff = as.numeric(coeff)
      var = gsub("x","",s[pos])
      var = as.numeric(var)
      r[var] = coeff
      
      if(grepl(">=",lin)){
        G = rbind(G, r)
        pos_in = grep("=",s)
        H = c(H,as.numeric(s[pos_in+1]))
        d = c(d,">=")
      }
      
      else if(grepl("<=",lin)){
        print("Exception.. check")
      }
      
      else{
        E = rbind(E, r)
        pos_in = grep("=",s)
        F = c(F,as.numeric(s[pos_in+1]))
        d = c(d,"=")
      }
    }
  }
  
  if(nrow(E)==1){
    E = NULL
  }else if(nrow(E)==2){
    E = E[-1,]
    E = t(as.matrix(E))
  }else{
    E = E[-1,]
  }
  
  if(nrow(G)==1){
    G = NULL
  }else if(nrow(G)==2){
    G = G[-1,]
    G = t(as.matrix(G))
  }else{
    G = G[-1,]
  }
  if(BB){
      lb = round(log(rep(lb_v,length(ini_vals)))/log(ep))
      ub = round(log(ini_vals + ub_v)/log(ep))
      G_lb = diag(x = -1, nrow = num_var, ncol = num_var)
      G_ub = diag(x = 1, nrow = num_var, ncol = num_var)
      sam_res = xsample(E= E, G = rbind(G,G_lb,G_ub), F = F, H = c(H,-lb,ub), type = "mirror", iter = n)
      if(typeof(sam_res)=="list"){
        samples = sam_res$X
      }else{
        samples = t(as.matrix(sam_res))
      }
  }else{
      sam_res = xsample(E= E, G = G, F = F, H = H, type = "mirror", iter = n)
      if(typeof(sam_res)=="list"){
        samples = sam_res$X
      }else{
        samples = t(as.matrix(sam_res))
      }
    }
  return(colMeans(samples))
}

euc_dist = function(s,s1, l_p){
  require(parallel)
  require("philentropy")
  out =  mclapply(1:nrow(s), function(i){
    d = c()
    for(j in 1:nrow(s1)){
      d = c(d,philentropy::distance(rbind(s1[j,], s[i,]), method = "minkowski", p =l_p)[1]) #computes the other distance.
    }
    return(d)
  }, mc.cores = 1)
  return(min(unlist(out)))
}

euc_dist_min_nominal = function(nom,pert,l_p){
  require("philentropy")
  dist =c()
  for(i in 1:nrow(nom)){
    d = c()
    for(j in 1:nrow(pert)){
    d = c(d,philentropy::distance(rbind(pert[j,], nom[i,]), method = "minkowski", p =l_p)[1]) #computes the other distance.
    
    }
    dist = c(dist, min(d))
  }
  names(dist) = rownames(nom)
  return(dist)
}

mergePolytopes = function(s_l){
  m = 0
  for(i in s_l){
    m = rbind(m,i)
  }
  m = m[-1,]
  if(is.null(dim(m)))
    m = t(as.matrix(m))
  rownames(m) = names(s_l)
  return(m)
}

convexhull = function(file=file){
  f = read.csv(file, sep =" ", header = F)
  f = as.matrix(f)
  for(i in 1:nrow(f)){
    for(j in 1:ncol(f)){
      if(grepl("/",as.character(f[i,j]))){
        st = strsplit(as.character(f[i,j]),"/")[[1]]
        f[i,j] = as.numeric(st[1]) / as.numeric(st[2])
      }
    }
  }
  class(f) <- "numeric"
  f_orig = f
  f = f[,2:ncol(f)]
  if(is.null(nrow(f))){
    f = t(as.matrix(f))
  }
  return(list("Mean"=f, "mat" = f_orig)) #computing the vertex centroid of a polytope
}


