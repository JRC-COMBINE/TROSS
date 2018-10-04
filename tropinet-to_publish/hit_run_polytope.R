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
# Read .lp file for hit and run algorithm
# Change the model specific details for num_var, num_parameter, init_values
#
computeDistances = function(path_p,num_var,ini_vals,p_list,ep,
                            model_name,lb_v,ub_v,
                            num_points,ncores,l_p,BB){
  require("limSolve")
  require("parallel")
  require("philentropy")
  maple_analysis = FALSE
  options(digits = 7, scipen = 0)
  
    s_l = list()
    
    # path to input directory, db/  
    path = paste(path_p, "db/", sep = "")
    tg_l_all = list()
    fp_l_all = list()
    fp_l = list()
    tg_l = list()

    tg_l_all = mclapply(p_list, function(p){
      fp_l = list() 
     
      # path to .lp files of the parent model directory, k*_gamma_0_model_name 
      g_f = paste(p,"_",model_name,"/",p, "_gamma_0_", model_name, sep = "")
      files = list.files(paste(path, g_f,sep = ""))
      files = files[grep(paste("ep",ep,".*.lp",sep = ""),files)]
      for(f in files){
        s_l[[f]] = samplePoints(file = paste(path, g_f,"/",f,  sep = ""), n = num_points, num_var = num_var,BB = BB, ini_vals = ini_vals, ep = 1/ep, lb_v = lb_v,ub_v = ub_v)
        }
      #merging the solution polytopes
      s_l_mat = mergePolytopes(s_l)      
      dis_list = list()
      dis_list_min_nom = list()
      # path to perturbed solution directories
      p_f = ''#paste("model",sep="")
      files_p = list.files(paste(path,p,"_",model_name,p_f,sep = ""))
      files_p = files_p[grep(paste(p,"_",sep=""),files_p)]
      for(f_p in files_p){
        if(!grepl("gamma_0_", f_p)){ #removing the gamma 0 case = same as unperturbed situation
          s_l_pert = list()
          files_pert = list.files(paste(path,p,"_",model_name,"/",p_f,f_p,sep = ""))
          files_pert = files_pert[grep(paste("ep",ep,".*.lp",sep = ""),files_pert)]
          if(length(files_pert) == 0 ){
            dis_list[[f_p]] = NA
          }else{
          for(f in files_pert){
            s_l_pert[[f]] = samplePoints(file = paste(path,p,"_",model_name,"/",p_f,f_p,"/",f, sep = ""), n = num_points, num_var = num_var,BB = BB, ini_vals = ini_vals, ep = 1/ep, lb_v = lb_v, ub_v = ub_v)
          }
          s_l_mat_pert = mergePolytopes(s_l_pert)
          dis_list[[f_p]] = euc_dist(s_l_mat,s_l_mat_pert,l_p)
          print("euc distance")
          dis_list_min_nom[[f_p]] = euc_dist_min_nominal(s_l_mat,s_l_mat_pert,l_p)
          }
        }
      }
      
      ############### Fixed point analysis#############
     if(maple_analysis){ 
      s_l = list()
      g_f = paste("Solutions_R/",model_name,sep = "")
      files = list.files(paste(path,g_f,sep = "")) 
      for(ft in files){
        f = readLines(paste(path,g_f,"/", ft, sep=""))
        fixedpt = strsplit(f," ")[[1]][seq(from = 3, to = 3*num_var, by = 3)]
        fixedpt = gsub("]","",fixedpt)
        fixedpt = gsub(",","",fixedpt)
        fixedpt = as.numeric(fixedpt)
        fixedpt = (log(fixedpt)/log(1/ep))
        s_l[[ft]] = t(as.matrix(fixedpt))
      }
      
      #merging the solution polytopes
      s_l_mat = mergePolytopes(s_l)
      dis_list_fp = list()
      p_f = paste("Solutions_R",sep="")
      files_p = list.files(paste(path,p_f,sep = ""))
      files_p = files_p[grep(paste(p,"_",sep=""),files_p)]
      for(f_p in files_p){
        if(!grepl("gamma_0_", f_p)){
          s_l_pert = list()
          files_pert = list.files(paste(path,p_f,"/",f_p,sep = ""))
          for(ft in files_pert){
            f = readLines(paste(path,p_f,"/",f_p,"/", ft, sep=""))
            fixedpt = strsplit(f," ")[[1]][seq(from = 3, to = 3*num_var, by = 3)]
            fixedpt = gsub("]","",fixedpt)
            fixedpt = gsub(",","",fixedpt)
            fixedpt = as.numeric(fixedpt)
            fixedpt = (log(fixedpt)/log(1/ep))
            s_l_pert[[ft]] = t(as.matrix(fixedpt))
          }
          s_l_mat_pert = mergePolytopes(s_l_pert)
          dis_list_fp[[f_p]] = euc_dist(s_l_mat,s_l_mat_pert,l_p)
        }
      }
     }
      
      par_list = list()
      for(i in unlist(files_p)){
        if(!grepl("_gamma_0_",i)){
          param  = readLines(paste(path,p,"_",model_name,"/",i,"/Params.txt", sep =""))
          param = gsub(" ", "", param, fixed = TRUE)
          par = as.numeric(gsub(paste(p,"=",sep=""),"",param[grep(paste(p,"=", sep=""),param)]))
          par_list[[i]] = par
        }
      }
      # Extracting the nominal parameter (of the given model)
      param  = readLines(paste(path, g_f,"/Params.txt", sep =""))
      param = gsub(" ", "", param, fixed = TRUE)
      nom_par = as.numeric(gsub(paste(p,"=",sep=""),"",param[grep(paste(p,"=", sep=""),param)]))
      
      
      par_sort = sort(unlist(par_list))
      if(maple_analysis){
      fp_l[[p]] = mean(unlist(dis_list_fp[names(par_sort)]))
      fp_l_all[[p]] = dis_list_fp[names(par_sort)]
      }
      return(list("A" = dis_list_min_nom[names(par_sort)] , "B" = dis_list[names(par_sort)]))
    },mc.cores = ncores)
    
    for(i in 1:length(p_list)){
        tg_l[[p_list[i]]] = mean(unlist(tg_l_all[[i]]$B), na.rm = T)
    }

    return(list("tg_l"=tg_l,"tg_l_all" = tg_l_all))
}

