function [x0,k,names,rnames,parnames,bc]=init 
 	 x0= [170.3 7.9 50.8 50.8 0 0 0 0 0 0 0 2.9 2.7 0 0 0 10 0 0 0 0]; 
	 k= [0.0026;0.056;0.0026;0.0026;0.056;0.002;0.016;0.002;0.016;0.002;0.016;0.002;0.016;0.0147472;0.0147472;0.000404;0.007;9.75e-05;4.875e-05;0.00047;0.00047;1;0.00555;0.00047;0.0047;0.00555;0.00055;0.00555;0.00055;0.00055;0.002;0.0052;0.016;0.016;0.016;1;10;10;10;178.2;101.6]; 
	 names= {'S2c.unnamed','S2n.unnamed','S4c.unnamed','S4n.unnamed','pS2c.unnamed','pS2n.unnamed','pS24c.unnamed','pS24n.unnamed','pS22c.unnamed','pS22n.unnamed','LRe.unnamed','RI.unnamed','RII.unnamed','LR.unnamed','RIe.unnamed','RIIe.unnamed','TIF.unnamed','pS24nTIF.unnamed','S4ubn.unnamed','S4ubc.unnamed','pS2nTIF.unnamed','PPase.unnamed','TGF.unnamed','FAM.unnamed'}; 
	 rnames= {'S2c <-> S2n','S4c <-> S4n','pS2c <-> pS2n','pS2c + S4c <-> pS24c','pS2n + S4n <-> pS24n','pS2c + pS2c <-> pS22c','pS2n + pS2n <-> pS22n','pS24c -> pS24n','pS22c -> pS22n','S2c + LRe -> pS2c + LRe','pS2n + PPase -> S2n + PPase','null -> RI','null -> RII','RI -> null','RII -> null','RI + RII + TGF -> LR + TGF','LR -> LRe','LR -> null','LR -> null','RI <-> RIe','RII <-> RIIe','LRe -> RI + RII','pS24n + TIF -> pS24nTIF','S4ubn -> S4ubc','S4ubc + FAM -> S4c + FAM','pS24nTIF -> pS2nTIF + S4ubn','pS2nTIF -> pS2n + TIF'}; 
	 parnames= {'kin','kex','kin','kin','kex','kon','koff','kon','koff','kon','koff','kon','koff','kinCIF','kinCIF','kphos','kdephos','pRI','pRII','kcd','kcd','ka','ki','kcd','klid','ki','kr','ki','kr','alphakr','konpS24nTIF','kinS4ub','kdub','koffpS24nTIF','koffpS2nTIF','PPase.unnamed0','TGF.unnamed0','FAM.unnamed0','C1','C2','C3'}; 
	 bc= [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1]; 
	 %tspan=[0 100000.000000]; 
	 %options = odeset('RelTol',2.220450e-14 ,'AbsTol',1.000000e-06); 
%[t,dx]=ode23s(@diffeqtgf_tif_10_h3_00557/,tspan,x0,options,k);
 end 
