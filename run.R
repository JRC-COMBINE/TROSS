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
# computes Tropical Senstivity Scores
#

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
  tolp(path_p, model_name, p_list, ep)

  ##compute distances
  result = computeDistances(path_p,num_var,ini_vals,p_list,ep, model_name,lb_v,ub_v, num_points, ncores, l_p, BB)
  
  ##compute scores
  tg_l = result$tg_l
  tg_l_all = result$tg_l_all
  return(list("tg_l"=tg_l,"tg_l_all" = tg_l_all))
}

result = computeTROSS(
              model_name = "tgf_tif_10_h3_00557", 
              path_ptcut = "/home/bq269718/tropinet_publication/tropinet/tropchapter/ptcut-v3-0-2/ptcut.py", #"/home/jk075370/tropinet/tropchapter/ptcut-v2-3-0/ptcut.py",
              p_list =  paste("k",seq(1,41), sep = ""),
              #p_list = "k1",
              path_p = paste(getwd(), "/", sep=""),
              num_var = 21,
              num_pars = 41,
              ini_vals = rep(0,21),
              ep = 11,
              lb_v = 10^-20,
              ub_v = 10^10,
              num_points = 1E4,             
	            BB = TRUE,
              ncores = 20,
              l_p = 2,
              norder = 3,
              order = ''#' --order 4,5,6,21,22,23,27,29,30,24,39,7,17,26,41,37,40,43,28,18'
              )

save(list = c("result"), file = paste("/home/bq269718/tropinet_publication/tropinet/tgf_tif_10_h3_00557_p_2.RData",sep=""), envir = .GlobalEnv)###
