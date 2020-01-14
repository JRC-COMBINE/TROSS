source("samplingpoints.R")
source("hit_run_polytope.R")
source("singleparam.R")
source("logtolp.R")
options(warn=-1)

# compute tropical sensitivity scores
computeTROSS <- function(model_name, path_ptcut, p_list, path_p, num_var, num_pars, ini_vals, ep, lb_v, ub_v, num_points,
                        BB, ncores, l_p, norder, order)
{

  ##compute tropical solutions
  perturbsinglep(model_name, p_list, ep, norder, path_ptcut, path_p, order, ncores)  
  tolp(path_p, model_name, p_list, ep, norder)

  ##compute distances
  result = computeDistances(path_p,num_var,ini_vals,p_list,ep, model_name,lb_v,ub_v, num_points, ncores, l_p, BB)
  
  ##compute scores
  tg_l = result$tg_l
  tg_l_all = result$tg_l_all
  return(list("tg_l"=tg_l,"tg_l_all" = tg_l_all))
}

result = computeTROSS(
              model_name = "tgf_tif_10_h3_00557", 
              path_ptcut = "../ptcut-v3-0-2/ptcut.py", 
              #p_list =  paste("k",seq(1,41), sep = ""),
              p_list = "k19",
              path_p = paste(getwd(), "/", sep=""),
              num_var = 21,
              num_pars = 41,
              ini_vals = rep(0,21),
              ep = 5,
              lb_v = 10^-20,
              ub_v = 10^10,
              num_points = 1E4,             
	            BB = TRUE,
              ncores = 20,
              l_p = 2,
              norder = 3,
              order = ' --order 4,5,6,21,22,23,27,29,30,24,39,7,17,26,41,37,40,43,28,18'
              )

save(list = c("result"), file = paste("/home/bq269718/tropinet_publication/tropinet/tgf_tif_10_h3_00557_p_2.RData",sep=""), envir = .GlobalEnv)###
