**Tropical Sensitivity Scores (TROSS)**

TROSS is a software implemented in R for studying the effects of perturbations in biochemical reaction networks describing
the intracellular processes. The software uses tropical geometry methods to determine metastable states of non-linear ordinary differential
equations parametrized by orders of magnitude. The changes in such states due to perturbations in the model parameters are reported as tropical sensitivity scores.

**Why should I use TROSS?**

TROSS determines the parameter sensitivity scores for a given biochemical reaction network based on the changes in the tropical solutions. 
The program determines the tropical sensitivity score for a given parameter by perturbing it with a predefined number of orders of magnitude up and down. 
The extension of the software to handle simultaneous perturbations of multiple parameters will be released soon.

**How do I use TROSS?**

| Arguments        |           |
| ------------- |:-------------:| 
| `model_name`    | Name of the model in `db/` folder.| 
| `path_ptcut`    | Path to ptcut.py file (see installation instructions).   |  
| `p_list`        | Vector of parameters to perform parameter perturbations. Each paremeter in this list will be perturbed individually for computing the tropical sensitivity score.|   
|`path_p`        |  Installation directory. Default is `paste(getwd(), "/", sep="")`|
|`num_var`        |  Number of variables|
|`num_pars`       |  Number of parameters|
|`ini_vals`       |  Initial values of the variables. The length should be same as `num_var`|
|`ep`             |  Value of epsilon. It should be same as the epsilon used to compute tropical solutions|
|`lb_v`           |  Lower bound on variable concentrations. This is used to put bounds during uniform sampling|
|`ub_v`           |  Upper bound on variable concentrations. This is used to put bounds during uniform sampling|
|`num_points`     |  Total number of sample points. Non-zero dimensional polytopes have infinite sample points|            
|`BB`             |  Apply the `lb_v` and `ub_v` bounds while performing uniform sampling|
|`ncores`         |  Number of cores to parallelise the program|
|`l_p`            |  p-value in l_p norm for distance computation |
|`norder`         |  The grid points are incremented and the sequence of equations for computing tropical solutions.|
|`order`          |  The ordering affects the computation time considerably. However, the tropical solutions are unaffected to the ordering of the equations.|

|Value        |           |
| ------------- |:-------------:| 
|`tg_l`        |  The tropical sensitivity score for each parameter in p_list.|

The parameters `ub_v` and `lb_v` should be adjusted in order to avoid infeasible bounds.
The perturbed output folders along with the tropical solutions will be found in `db/` folder. The default parameter values will be perturbed by the specified order of magnitude depending on epsilon. For example, for perturbation of parameter `k19` that takes the default value `4.875e-05`, `norder =3` and `ep = 5`, the program will generate seven directories: `k19_gamma_-3_modelname`, `k19_gamma_-2_modelname`, `k19_gamma_-1_modelname`, `k19_gamma_0_modelname`, `k19_gamma_1_modelname`, `k19_gamma_2_modelname` and `k19_gamma_3_modelname` respectively. The corresponding perturbed parameters, `k19` will take the values: `3.9e-07`, `1.95e-06`, `9.75e-06`, `4.875e-05`, `0.00024375`, `0.00121875` and `0.00609375` respectively.

**Examples**
```source("run.R")
result = computeTROSS(
              model_name = "tgf_tif_10_h3_00557", 
              path_ptcut = "../ptcut-v2-3-0/ptcut.py",
              p_list =  c('k1'),
              path_p = paste(getwd(), "/", sep=""),
              num_var = 21,
              num_pars = 41,
              ini_vals = rep(0,21),
              ep = 11,
              lb_v = 10^-20,
              ub_v = 10^10,
              num_points = 1E4,             
	            BB = TRUE,
              ncores = 3,
              l_p = 2,
              norder = 3,
              order = ''
              )
```

**OS Compatibility**

TROSS has been tested in the Linux OS. In the next releases, we will offer compatibilties for MacOS/Windows.

**Dependencies**

The following softwares need to be pre-installed before before running this program:
1. 
 * [Python 2.7](https://www.python.org/download/releases/2.7/) or greater.
 * [R 3.5 ](https://cran.r-project.org/bin/windows/base/).
 * [SageMath 7.6](http://www.sagemath.org/) or greater.
2. Tropical Equilibration Software:
 * [PtCut 3.0.2](http://wrogn.com/ptcut/).
3. Additional R packages:
 * [Parallel](https://www.rdocumentation.org/packages/parallel/versions/3.5.1)
 * [limSolve](https://www.rdocumentation.org/packages/limSolve/versions/1.5.5.3/topics/limSolve-package)
 * [philentropy](https://cran.r-project.org/web/packages/philentropy/index.html). 
4. Biochemical Reaction Network Models can be downloaded from the [Biomodels database](https://www.ebi.ac.uk/biomodels-main/). Sample models are included in the `db/` directory.
 
**Installation Instructions**

* Install Python2.7, R3.5 and SageMath7.6. Follow the respective software instructions. 
* Install R packages Parallel, limSolve and philentropy using CRAN. 
* Download PtCut, and copy the path to the `~/PtCut/ptcut.py` to `path_ptcut` argument of the TROSS function.
* Download Biomodel of interest and copy to `db/` folder of this repository. Adapt the `model_name`, `num_var`, `num_pars` and `ini_vals` arguments of the TROSS function accordingly.
* Set list of parameters to be perturbed, `p_list` and number of orders of magnitude of perturbation, `norder` and execute the function.

**License**

TROSS is an open source software and is licensed under LGPL.

**Getting help**

For queries regarding the software write to: samal@aices.rwth-aachen.de / krishnan@aices.rwth-aachen.de

**Citing TROSS**

S. S. Samal, J. Krishnan, A. H. Esfahani, C. Lüders, A. Weber, O. Radulescu, Metastable regimes and tipping points of biochemical networks with potential applications in precision medicine,
Automated Reasoning for Systems Biology and Medicine, springer (Computational Biology Series), Summer 2018 (under review).
