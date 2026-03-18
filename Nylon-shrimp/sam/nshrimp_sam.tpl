TOP_OF_MAIN_SECTION
 //###########################################################################
 arrmblsize = 50000000; 
 gradient_structure::set_GRADSTACK_BUFFER_SIZE(1.e7); 
 gradient_structure::set_CMPDIF_BUFFER_SIZE(1.e7); 
 gradient_structure::set_MAX_NVAR_OFFSET(5000); 
 gradient_structure::set_NUM_DEPENDENT_VARIABLES(5000);

DATA_SECTION
  init_int nanos  
  init_int nedades
  init_number edad_ini
  init_number delta_edad
  init_int ntallas_n 
  init_matrix indices_n(1,nanos,1,7)//se agregan variaciones en q,s
  init_vector Tallas_n(1,ntallas_n) 
  init_matrix Cl_n(1,nanos,1,ntallas_n)
  init_matrix Nlcruceros_n(1,nanos,1,ntallas_n)
  init_matrix Wmed_n(1,nanos,1,ntallas_n)
  init_int ntallas_s	
	    
  init_matrix indices_s(1,nanos,1,7)//se agregan variaciones en q,s
  init_vector Tallas_s(1,ntallas_s) 	    
  init_matrix Cl_s(1,nanos,1,ntallas_s)
  init_matrix Nlcruceros_s(1,nanos,1,ntallas_s)
  init_matrix Wmed_s(1,nanos,1,ntallas_s)  
	  	  	  
  int reporte_mcmc

  !! ad_comm::change_datafile_name("control_N.ctl");
  init_vector msex_n(1,ntallas_n)		    
  init_number cv_Ro
  init_number sigmaRR
  init_vector cvar_n(1,6)	
  init_vector nmus_n(1,2)
  init_int    opt_qCru_n
  init_ivector opt_devq_n(1,nanos)
  init_int    opt_qCPUE_n
  init_ivector opt_devqCPUE_n(1,nanos)	  
  init_int    opt_Sel1_n	  
  init_ivector opt_Sel2_n(1,nanos)  
  init_int    opt_Sel3_n	  
  init_int    opt_Sel4_n
  init_int    opt_Sel5_n

  init_vector parbiol_n(1,5)
	  
  init_int    opt_VB1_n
  init_int    opt_VB2_n
  init_int    opt_VB3_n
  init_int    opt_VB4_n
	  
  init_int    opt_VB5_n
  init_int    opt_Rmed_n  ////////REVISAR
  init_int    opt_devR_n  ////////REVISAR
  init_int    opt_devNo_n ////////REVISAR
  init_int    opt_F_n
  init_int    opt_M_n
  init_int    nanos_proy_n
	  
  init_int    npbr
  init_number pR_n
  init_vector Fpbr_n(1,npbr)
  //!!cout<<" "<<Fpbr_n<<endl;exit(1); 	   	  	  	  

  !! ad_comm::change_datafile_name("control_S.ctl");
  init_vector msex_s(1,ntallas_s) 	   
  init_vector cvar_s(1,8)
  init_vector nmus_s(1,2)
  init_int    opt_qCru_s
  init_ivector opt_devq_s(1,nanos)
  init_int    opt_qCPUE_s
  
  init_ivector opt_devqCPUE_s(1,nanos)
  init_int    opt_Sel1_s
  init_ivector opt_Sel2_s(1,nanos)
  init_int    opt_Sel3_s
	  
  init_int    opt_Sel4_s
	  
  init_int    opt_Sel5_s

  init_vector parbiol_s(1,4)
	  
  init_int    opt_VB1_s
  init_int    opt_VB2_s
  init_int    opt_VB3_s
  init_int    opt_VB4_s
  init_int    opt_VB5_s
  init_int    opt_Rmed_s  ////////REVISAR
  init_int    opt_devR_s  ////////REVISAR
  init_int    opt_devNo_s ////////REVISAR
  init_int    opt_F_s
  init_int    opt_M_s	  
  init_int    nanos_proy_s  
  init_number pR_s
  init_vector Fpbr_s(1,npbr)
  init_int phs_prop //NUEVO
  init_number cv_logitPr //Nuevo Cubillos
	  
	  
	 
  //cout<<Fpbr_s<<endl;exit(0);
  
INITIALIZATION_SECTION
// defino un valor inicial de log_reclutamiento promedio (factor de escala)

 
 log_F_n            -1.0
 log_A50f_one_n     1.09
 log_Df_one_n       -0.7
 log_A50cru_n       1.09
 log_Dcru_n         -0.7
 log_sf_n            0
 log_sda_n           0.40
 log_sda2_n          0.40
 log_qCru_n          0
 dev_log_A50f_n      0
 dev_log_Df_n        0
 log_Lo_n            2.9
	   
 log_Ro         6 ///////REVISAR
 log_F_s            -1.0
 log_A50f_one_s     1.09
 log_Df_one_s       -0.7
 log_A50cru_s       1.09
 log_Dcru_s         -0.7
 log_sf_s            0
 log_sda_s           0.40
 log_sda2_s          0.40
 log_qCru_s          0
 dev_log_A50f_s      0 
 dev_log_Df_s        0
 log_Lo_s            2.9	   
 //log_P0              -0.7   



PARAMETER_SECTION

// parametros selectividad norte
 init_bounded_number log_A50f_one_n(0.7,1.6,opt_Sel1_n) 		 
 init_bounded_number log_Df_one_n(0.1,0.7,opt_Sel1_n)//MODIFICADO EL 0

	   
 // parametros selectividad sur
 init_bounded_number log_A50f_one_s(0.7,1.6,opt_Sel1_s)  
 init_bounded_number log_Df_one_s(0.1,0.7,opt_Sel1_s)//MODIFICADO EL 0
	  
		//Si los datos no informan estas desviaciones, desactívalas momentáneamente usando opt_Sel2_n = 0 y opt_Sel2_s = 0.
 // desvios de los parametros selectividad flota norte
		 init_number_vector dev_log_A50f_n(1,nanos,opt_Sel2_n)  
		 init_number_vector dev_log_Df_n(1,nanos,opt_Sel2_n)
		 
 // desvios de los parametros selectividad flota sur
		init_number_vector dev_log_A50f_s(1,nanos,opt_Sel2_s)  
		init_number_vector dev_log_Df_s(1,nanos,opt_Sel2_s)	
				 	 
 // parametros selectividad doble normal norte
 init_bounded_number log_muf_n(-9,1.24,opt_Sel3_n)//REVISAR
 init_bounded_vector log_sf_n(1,2,-10,3,opt_Sel3_n)
		 
 // parametros selectividad doble normal sur
 init_bounded_number log_muf_s(-9,1.24,opt_Sel3_s)//REVISAR
 init_bounded_vector log_sf_s(1,2,-10,3,opt_Sel3_s)		 
		 		 

 // parametros selectividad unica Cruceros norte
 init_bounded_number log_A50cru_n(0.6,1.7,opt_Sel4_n)  
 init_bounded_number log_Dcru_n(0.1,0.7,opt_Sel4_n)
		 
 // parametros selectividad unica Cruceros sur
 init_bounded_number log_A50cru_s(0.6,1.7,opt_Sel4_s)  
 init_bounded_number log_Dcru_s(0.1,0.7,opt_Sel4_s)		 

 // Recruits and F mortalities
 // parametros reclutamientos y mortalidades)
 //init_number log_Rmed(opt_Rmed)//REVISAR
 init_bounded_number log_Ro(5,20)// init_number log_Ro(1);	  
 
  init_bounded_vector log_desv_No_norte(1,nedades,-10,10,opt_devNo_n)
  	 
 //init_bounded_vector log_desv_No_sur(1,nedades,-10,10,opt_devNo_s)	 
 init_bounded_vector log_desv_No_sur(1,nedades,-10,10,opt_devNo_s) //PROBANDO UN SUAVIZADO
 init_bounded_number lambda_suav(0.001,10)	                                      //PROBANDO UN SUAVIZADO
 
 //init_bounded_dev_vector log_desv_Rt_norte(1,nanos,-10,10)//,opt_devR_n) 
 //init_bounded_vector log_desv_Rt_sur(1,nanos,-10,10)//,opt_devR_s) 
 
 init_bounded_vector log_desv_Rt_norte(1,nanos,-10,10,opt_devR_n)
 init_bounded_number lambda_Rtn(0.001,10)  // penalización suavizado Rt norte
 init_bounded_vector log_desv_Rt_sur(1,nanos,-10,10,opt_devR_s)
		 
 init_bounded_vector log_F_n(1,nanos,-20,2,opt_F_n) 
 init_bounded_vector log_F_s(1,nanos,-20,1.5,opt_F_s) 
 //init_bounded_number log_P0(-4.6,-0.01)// valor de proporcion de mezcla


  // Desviación (en log) de la RW (controla suavizado de la trayectoria)
  // Nivel inicial en logit (año 1) de la proporción norte (o mezcla)  
  init_bounded_number logit_prop(-5,5,1) // prop de machos en el reclutamiento (comienza en el valor medio entre 0.1 y 0.9, es decir 0.5) fase 1
  // Incrementos anuales (RW1) para logit(Proporción), del año 1→2, 2→3, …, (nanos-1)→nanos
  init_vector dlogit_Pr(1,nanos-1,phs_prop)	//Cubillos
  //init_number logit_Pr0(phs_prop)  //Cubillos
  vector logit_Pr(1,nanos)
  // proporcion norte
  vector Pr(1,nanos)
		   	  
 // flota norte
 init_bounded_number log_M_n(-3,2,opt_M_n)
 // flota sur
 init_bounded_number log_M_s(-3,1.5,opt_M_s)		

// capturabilidades norte
 init_number log_qCru_n(opt_qCru_n)
 init_number log_qCPUE_n(opt_qCPUE_n)
 init_number_vector devq_n(1,nanos-1,opt_devq_n)
 init_number_vector devqCPUE_n(1,nanos-1,opt_devqCPUE_n)
		 
		 
 // capturabilidades sur
 init_number log_qCru_s(opt_qCru_s)
 init_number log_qCPUE_s(opt_qCPUE_s)
 init_number_vector devq_s(1,nanos-1,opt_devq_s)
 init_number_vector devqCPUE_s(1,nanos-1,opt_devqCPUE_s)		
				 

// crecimiento norte
 init_bounded_number log_Lo_n(2.8,3.2,opt_VB1_n)
 init_bounded_number log_cva_n(-3.9,-0.7,opt_VB2_n)
 init_bounded_number log_sda_n(-2.9,1.2,opt_VB3_n)
 init_bounded_vector log_sda2_n(1,nedades,-2.9,1.2,opt_VB4_n)
 init_bounded_number log_k_n(-1.5,-0.5,opt_VB5_n)
// crecimiento sur
 init_bounded_number log_Lo_s(2.8,3.2,opt_VB1_s)
 init_bounded_number log_cva_s(-3.9,-0.7,opt_VB2_s)
 init_bounded_number log_sda_s(-2.9,1.2,opt_VB3_s)
 init_bounded_vector log_sda2_s(1,nedades,-2.9,1.2,opt_VB4_s)
 init_bounded_number log_k_s(-1.5,-0.5,opt_VB5_s)		
	

//Defino las variables de estado 
 vector ano(1,nanos)
 vector Unos_edad(1,nedades)
 vector Unos_anos(1,nanos)
 vector Unos_tallas(1,ntallas_n)	
 vector Desemb_n(1,nanos)
 vector Desemb_s(1,nanos)		 
 vector Bcrucero_n(1,nanos)
 vector Bcrucero_s(1,nanos)
		 
 vector CPUE_n(1,nanos)
 vector CPUE_s(1,nanos)	

 sdreport_vector norteBD(1,nanos)
 sdreport_vector surBD(1,nanos)
 vector cv(1,nanos)
 number norteBD_end;
 number surBD_end; 		 	 
 vector cv1_n(1,nanos)
 vector cv2_n(1,nanos)
 vector cv3_n(1,nanos)
 
 vector cv1_s(1,nanos)
 vector cv2_s(1,nanos)
 vector cv3_s(1,nanos)		 
		 		 
 //vector Unos_edad(1,nedades)
 vector Unos_tallas_n(1,ntallas_n)
 vector Unos_tallas_s(1,ntallas_s)

 vector sigma_edad_n(1,nedades);
 vector sigma_edad_s(1,nedades);
 vector mu_edad_n(1,nedades);
 vector mu_edad_s(1,nedades);
 

	  
 vector Bcru_n(1,nanos);
 vector Bcru_s(1,nanos);
 vector prior(1,12);
 vector penalty(1,5);
 

 vector Neq_n(1,nedades);
 vector Neq_s(1,nedades); 
 //vector Neqv(1,nedades);
 vector likeval(1,11);
 vector SDo_n(1,nanos);
 vector SDo_s(1,nanos);
 number SDo2_n;
 number SDo2_s;
 
 /////
 vector edades(1,nedades)
 vector Scru_1_n(1,nedades);
 vector Scru_2_n(1,nedades);
 vector log_A50f_n(1,nanos)
 vector log_Df_n(1,nanos)
 vector log_A50R2_n(1,nanos)
 vector log_DR2_n(1,nanos)
 vector qCru_n(1,nanos)
 vector qCPUE_n(1,nanos)
	 
 vector Scru_1_s(1,nedades);
 vector Scru_2_s(1,nedades);
 
 vector log_A50f_s(1,nanos)
 vector log_Df_s(1,nanos)
 vector log_A50R2_s(1,nanos)
 vector log_DR2_s(1,nanos)
 vector qCru_s(1,nanos)
 vector qCPUE_s(1,nanos)	 
	 
 matrix Sflo_n(1,nanos,1,nedades)
 matrix Scru_n(1,nanos,1,nedades)
 matrix Fnorte(1,nanos,1,nedades)
 matrix Z_n(1,nanos,1,nedades)
 matrix S_n(1,nanos,1,nedades)
 matrix Sflo_s(1,nanos,1,nedades)
 matrix Scru_s(1,nanos,1,nedades)
 matrix Fsur(1,nanos,1,nedades)
 matrix Z_s(1,nanos,1,nedades)
 matrix S_s(1,nanos,1,nedades)	 
	 
 //REVISAR	 
 matrix norteN(1,nanos,1,nedades);
 matrix surN(1,nanos,1,nedades) 
 matrix NM_n(1,nanos,1,nedades)	 
 matrix NM_s(1,nanos,1,nedades)
 matrix Nv_n(1,nanos,1,nedades)
 matrix Nv_s(1,nanos,1,nedades)
	 
 //////	 
 matrix Cedad_n(1,nanos,1,nedades)
 matrix Prob_talla_n(1,nedades,1,ntallas_n)
 matrix P1_n(1,nedades,1,ntallas_n)
 matrix P2_n(1,nedades,1,ntallas_n)
 matrix P3_n(1,nedades,1,ntallas_n)
 matrix Cl_pred_n(1,nanos,1,ntallas_n)
 matrix Nlcruceros_pred_n(1,nanos,1,ntallas_n)
 matrix pobs_n(1,nanos,1,ntallas_n)
 matrix ppred_n(1,nanos,1,ntallas_n)
 matrix pobs_cru_n(1,nanos,1,ntallas_n)
 matrix ppred_cru_n(1,nanos,1,ntallas_n)
	 
 matrix Cedad_s(1,nanos,1,nedades)
 matrix Prob_talla_s(1,nedades,1,ntallas_s)
 matrix P1_s(1,nedades,1,ntallas_s)
 matrix P2_s(1,nedades,1,ntallas_s)
 matrix P3_s(1,nedades,1,ntallas_s)
 matrix Cl_pred_s(1,nanos,1,ntallas_s)
 matrix Nlcruceros_pred_s(1,nanos,1,ntallas_s)
 matrix pobs_s(1,nanos,1,ntallas_s)
 matrix ppred_s(1,nanos,1,ntallas_s)
 matrix pobs_cru_s(1,nanos,1,ntallas_s)
 matrix ppred_cru_s(1,nanos,1,ntallas_s)	 
 number SSBo_n	
 number SSBo_s	 
 number SSBo  
 number h
 number suma1
 number suma2
 number suma3
 number suma4
 number pStotf
 number pSf
 vector Rpred(1,nanos);
 //number P0;

 number Linf_n
 number Linf_s
 number k_n
 number k_s
 number cv_edad
 number sd_edad
 number Lo_n
 number Lo_s
 number M_norte
 number M_sur
 number Npplus_n
 number Npplus_s
 number Nvplus_n
 number Nvplus_s

// los arreglos usados en la proyeccion

  number Yp
  number factor
  vector temp0(1,nedades)
  vector temp1(1,nedades)
  number Fx
  vector Wedad(1,nedades)
  number alfa
  number beta

 vector Np_n(1,nedades)
 vector Np_s(1,nedades)
 vector NMp_n(1,nedades)  
 vector NMp_s(1,nedades)
 vector Sp_n(1,nedades)
 vector Sp_s(1,nedades)	  
 vector Fp_n(1,nedades)
 vector Fp_s(1,nedades)	  
 vector Zp_n(1,nedades)
 vector Zp_s(1,nedades)
		   
 vector Cap_n(1,ntallas_n)
 vector Cap_s(1,ntallas_s)
	  

 matrix YTP_n(1,nanos_proy_n,1,npbr)
 matrix YTP_s(1,nanos_proy_s,1,npbr)
	  
 matrix Bp_n(1,nanos_proy_n,1,npbr)
 matrix Bp_s(1,nanos_proy_s,1,npbr)
	  
 matrix SDp_n(1,nanos_proy_n,1,npbr)
 matrix SDp_s(1,nanos_proy_s,1,npbr)

 vector Nvp_n(1,nedades)
 vector Nvp_s(1,nedades)
	  
 vector Sfp_n(1,nedades)
 vector Sfp_s(1,nedades)
	  
 vector SDvp_n(1,nanos_proy_n)
 vector SDvp_s(1,nanos_proy_s)
 vector Flast_norte(1,nanos)
 vector Flast_sur(1,nanos)  
 sdreport_vector CPUE_pred_n(1,nanos);
 sdreport_vector CPUE_pred_s(1,nanos);

 
 sdreport_vector Bcrucero_pred_n(1,nanos);
 sdreport_vector Bcrucero_pred_s(1,nanos);
 sdreport_vector Desemb_pred_n(1,nanos);
 sdreport_vector Desemb_pred_s(1,nanos); 
 vector SD_n(1,nanos) //
 vector SD_s(1,nanos) //
 vector RPR_n(1,nanos) //
 vector RPR_s(1,nanos) //
 vector RPR2_n(1,nanos) //
 vector RPR2_s(1,nanos) //
	  
 //sdreport_vector Reclutas(1,nanos-1)
 //sdreport_number Flast
 sdreport_vector CTP_n(1,npbr)
 sdreport_vector CTP_s(1,npbr)
	 
 vector RPRp_n(1,npbr)
 vector RPRp_s(1,npbr)
	 
 vector Btot_n(1,nanos);
 vector Btot_s(1,nanos);
 number Pr_proj;
 //number Pr //nuevo	
	 
 vector Bv_n(1,nanos);
 vector Bv_s(1,nanos);
 number Pr_eq;
 vector Pr_t(1,nanos);
 matrix Ftotal(1,nanos,1,nedades);
 sdreport_vector Fmax(1,nanos);
 sdreport_vector SSB(1,nanos); //biomasa desovante total
 sdreport_vector rt(1,nanos);
  objective_function_value f


PRELIMINARY_CALCS_SECTION
// leo la matriz de indices

  ano=column(indices_n,1);// asigno la 1 columna de indices a "años"
  Bcrucero_n=column(indices_n,2);
  cv1_n=column(indices_n,3);
  CPUE_n=column(indices_n,4);
  cv2_n=column(indices_n,5);
  Desemb_n=column(indices_n,6);
  cv3_n=column(indices_n,7);
  //opt_qCPUE_n= column(indices_n,8);
  //opt_devqCPUE_n= column(indices_n,9);
  //opt_Sel2_n= column(indices_n,10);
  
  Bcrucero_s=column(indices_s,2);
  cv1_s=column(indices_s,3);
  CPUE_s=column(indices_s,4);
  cv2_s=column(indices_s,5);
  Desemb_s=column(indices_s,6);
  cv3_s=column(indices_s,7);
  //opt_devq_s=column(indices_s,8);
  //opt_devqCPUE_s=column(indices_s,9);
  //opt_Sel2_s=column(indices_s,10);  

  Unos_edad=1;// lo uso en  operaciones matriciales con la edad
  Unos_anos=1;// lo uso en operaciones matriciales con el año
  Unos_tallas=1;// lo uso en operaciones matriciales con el año
  Unos_tallas_n=1;
  Unos_tallas_s=1;
  reporte_mcmc=0;

RUNTIME_SECTION
  maximum_function_evaluations 200,1000,3000,5000
  convergence_criteria  1e-3,1e-5,1e-5,1e-6


PROCEDURE_SECTION
// para comentar mas de una lina  /*.........*/

  Eval_selectividad();
  Eval_mortalidades();
  Eval_prob_talla_edad();
  Eval_abundancia(); 
  Eval_capturas_predichas();
  Eval_deinteres();
  Eval_logverosim();
  Eval_funcion_objetivo();

  // Penalización por suavidad entre edades (sur)
  for (int a = 2; a <= nedades; a++) {
      f += square(log_desv_No_sur(a) - log_desv_No_sur(a-1)) * lambda_suav;
  }
  // Penalización por suavidad para Rt_norte
  dvariable pen_Rtn = 0;
  for (int y = 2; y <= nanos; y++) {
      pen_Rtn += square(log_desv_Rt_norte(y) - log_desv_Rt_norte(y - 1));
  }
  f += pen_Rtn * lambda_Rtn;

  if (last_phase()){
  Eval_CTP();
  Eval_mcmc();}
  
 

FINAL_SECTION
	Write_R();

FUNCTION Eval_selectividad
  int i;

  edades.fill_seqadd(edad_ini,delta_edad);
  
  //norte

  log_A50f_n(1)=log_A50f_one_n;  
  log_Df_n(1)=log_Df_one_n;
  

  for (int i=2;i<=nanos;i++){
  log_A50f_n(i)=log_A50f_n(i-1)+dev_log_A50f_n(i-1);
  log_Df_n(i)=log_Df_n(i-1)+dev_log_Df_n(i-1);}
  

    Scru_1_n=elem_div(Unos_edad,(1+exp(-1.0*log(19)*(edades-exp(log_A50cru_n))/exp(log_Dcru_n))));
   

 //sur

    log_A50f_s(1)=log_A50f_one_s;
    log_Df_s(1)=log_Df_one_s;

    for (int i=2;i<=nanos;i++){
    log_A50f_s(i)=log_A50f_s(i-1)+dev_log_A50f_s(i-1);
    log_Df_s(i)=log_Df_s(i-1)+dev_log_Df_s(i-1);}

      Scru_1_s=elem_div(Unos_edad,(1+exp(-1.0*log(19)*(edades-exp(log_A50cru_s))/exp(log_Dcru_s))));
     
	  

  
  //norte

  for (i=1;i<=nanos;i++)
  {Sflo_n(i)=elem_div(Unos_edad,(1+mfexp(-1.0*log(19)*(edades-mfexp(log_A50f_n(i)))/mfexp(log_Df_n(i)))));
  Scru_n(i)=Scru_1_n;
  }

  //Sur

  for (i=1;i<=nanos;i++)
  {Sflo_s(i)=elem_div(Unos_edad,(1+mfexp(-1.0*log(19)*(edades-mfexp(log_A50f_s(i)))/mfexp(log_Df_s(i)))));
  Scru_s(i)=Scru_1_s;
  }

  
// parametros selectividad doble normal
  
  //norte

  if(opt_Sel3_n>0){// selectividad doble_normal unica 
    for (i=1;i<=nanos;i++){
      Sflo_n(i)=mfexp(-1/(2*square(exp(log_sf_n(1))))*square((edades-exp(log_muf_n))));
      for (int j=1;j<=nedades;j++){
       if(edades(j)>exp(log_muf_n)){
       Sflo_n(i,j)=mfexp(-1/(2*square(exp(log_sf_n(2))))*square(-1.*(edades(j)-exp(log_muf_n))));}
    }}}
     
  if(opt_Sel5_n>0)// selectividad 1.0
      {Scru_n=1;}
  
  //sur

  if(opt_Sel3_s>0){// selectividad doble_normal unica 
    for (i=1;i<=nanos;i++){
      Sflo_s(i)=mfexp(-1/(2*square(exp(log_sf_s(1))))*square((edades-exp(log_muf_s))));
      for (int j=1;j<=nedades;j++){
       if(edades(j)>exp(log_muf_s)){
       Sflo_s(i,j)=mfexp(-1/(2*square(exp(log_sf_s(2))))*square(-1.*(edades(j)-exp(log_muf_s))));}
    }}}
     
  if(opt_Sel5_s>0)// selectividad 1.0
      {Scru_s=1;} 
  
  


FUNCTION Eval_mortalidades


  M_norte=parbiol_n(4);
  M_sur=parbiol_s(4);


  if (active(log_M_n)){M_norte=mfexp(log_M_n);}
  Fnorte=elem_prod(outer_prod(mfexp(log_F_n),Unos_edad),Sflo_n);
  if (active(log_M_s)){M_sur=mfexp(log_M_s);}
  Fsur=elem_prod(outer_prod(mfexp(log_F_s),Unos_edad),Sflo_s);
  
  Z_n=Fnorte+M_norte;
  Z_s=Fsur+M_sur;
  
  S_n=mfexp(-1.0*Z_n);
  S_s=mfexp(-1.0*Z_s);
  
  Flast_norte= mfexp(log_F_n);
  Flast_sur=mfexp(log_F_s);
  
  Ftotal = Fnorte + Fsur;
  for (int i = 1; i <= nanos; i++){
  Fmax(i) = max(Ftotal(i)); 	
  }
  
  
  //cout << "S_s "<< S_s << endl; exit(1);
  
  
FUNCTION Eval_prob_talla_edad
	
  	//por zona
	
  	//norte //////

    Linf_n=parbiol_n(1);
    k_n=parbiol_n(2);
    Lo_n=parbiol_n(3);

    if (active(log_Lo_n)){Lo_n=mfexp(log_Lo_n);}
    if (active(log_k_n)){k_n=mfexp(log_k_n);}

   int i, j;
 
   // genero una clave edad-talla para otros calculos. Se modela desde L(1)
    mu_edad_n(1)=Lo_n;
	
	

    for (i=2;i<=nedades;i++){
     mu_edad_n(i)=Linf_n*(1-exp(-k_n))+exp(-k_n)*mu_edad_n(i-1);
     }

      cv_edad=mfexp(log_cva_n);
      sigma_edad_n=cv_edad*mu_edad_n;  // proporcional con la talla por defecto
 
    if (active(log_sda_n)){
      sigma_edad_n=mfexp(log_sda_n);}// constante

    if (active(log_sda2_n)){// independiente
     sigma_edad_n=mfexp(log_sda2_n);
      }

   //---------------------------------------------------------------
    for (i=1;i<=nedades;i++){
      P1_n(i)=(Tallas_n-mu_edad_n(i))/sigma_edad_n(i);

    for (j=1;j<=ntallas_n;j++){
      P2_n(i,j)=cumd_norm(P1_n(i,j));}}
   
    for (i=1;i<=nedades;i++){
       for (j=2;j<=ntallas_n;j++){
         P3_n(i,j)=P2_n(i,j)-P2_n(i,j-1);}}
		 
		 
		 

    Prob_talla_n=elem_div(P3_n+1e-16,outer_prod(rowsum(P3_n+1e-16),Unos_tallas_n));
	
  	//cout << "Prob_talla_n "<< Prob_talla_n << endl; exit(1);
  
    //sur ///
  
    Linf_s=parbiol_s(1);
    k_s=parbiol_s(2);
    Lo_s=parbiol_s(3);

    if (active(log_Lo_s)){Lo_s=mfexp(log_Lo_s);}
    if (active(log_k_s)){k_s=mfexp(log_k_s);}

   //int i, j;
 
   // genero una clave edad-talla para otros calculos. Se modela desde L(1)
    mu_edad_s(1)=Lo_s;
	

    for (i=2;i<=nedades;i++){
     mu_edad_s(i)=Linf_s*(1-exp(-k_s))+exp(-k_s)*mu_edad_s(i-1);
     }

      cv_edad=mfexp(log_cva_s);
      sigma_edad_s=cv_edad*mu_edad_s;  // proporcional con la talla por defecto
 
    if (active(log_sda_s)){
      sigma_edad_s=mfexp(log_sda_s);}// constante

    if (active(log_sda2_s)){// independiente
     sigma_edad_s=mfexp(log_sda2_s);
      }

   //---------------------------------------------------------------
    for (i=1;i<=nedades;i++){
      P1_s(i)=(Tallas_s-mu_edad_s(i))/sigma_edad_s(i);

    for (j=1;j<=ntallas_s;j++){
      P2_s(i,j)=cumd_norm(P1_s(i,j));}}
   
    for (i=1;i<=nedades;i++){
       for (j=2;j<=ntallas_s;j++){
         P3_s(i,j)=P2_s(i,j)-P2_s(i,j-1);}}
		 
	    	//cout << "P3_s "<< P3_s << endl; exit(1);
		 

    Prob_talla_s=elem_div(P3_s+1e-16,outer_prod(rowsum(P3_s+1e-16),Unos_tallas_s)); 
  
	//cout << "Prob_talla_n "<< Prob_talla_n << endl; exit(1);
  

  

FUNCTION Eval_abundancia
	
	
 int i, j;

 //dvar_vector logit_Pr(1, nanos); Cubillos borró este line
 logit_Pr(1) = logit_prop; //asigna el numero a la primera posicion del vector RW
 if (active(dlogit_Pr))
   {
     for (i = 1; i < nanos; i++) //cubillos
       logit_Pr(i + 1) = logit_Pr(i) + dlogit_Pr(i);
   }
   else
   {
     for (i = 1; i <= nanos - 1; i++)
       logit_Pr(i + 1) = logit_Pr(i); // si la fase no está activa, queda constante
   }
   for(i =1;i<=nanos;i++){
	   Pr(i) = mfexp(logit_Pr(i))/(1 + mfexp(logit_Pr(i)));
   }
  
  h=parbiol_n(5); //steppnes valor ctl
  //cout << "dlogit_Pr " << dlogit_Pr << endl;
  //cout << "logit_Pr " << logit_Pr << endl;
  //cout << "Pr "<< Pr << endl; exit(1);

//-------ZONA NORTE--------------------------------------- new
 // reclutas anuales a la edad 2
  for (i=1;i<=nanos;i++)
  { 
  //norteN(i,1)=P0*mfexp(log_Ro+log_desv_Rt_norte(i));}
  norteN(i,1)=Pr(i)*mfexp(log_Ro+log_desv_Rt_norte(i));}
   
 // Abundancia inicial en equilibrio
  //Neq_n(1)=P0*mfexp(log_Ro);
  Neq_n(1)=Pr(1)*mfexp(log_Ro);
  
  for (i=2;i<=nedades;i++)
  {Neq_n(i)=Neq_n(i-1)*exp(-1*M_norte);}
  Neq_n(nedades)=Neq_n(nedades)/(1-exp(-1*M_norte));  
  SSBo_n=sum(elem_prod(Neq_n*exp(-0.67*M_norte),Prob_talla_n*elem_prod(msex_n,colsum(Wmed_n)/nanos)));
  
  //cout << "SSBo_n "<< SSBo_n << endl; exit(1);

  // Abundancia inicial
  for (j=2;j<=nedades;j++){
  norteN(1)(j)=norteN(1,j-1)*exp(-Z_n(1,j-1))*exp(log_desv_No_norte(j-1));}
  
  
  norteBD(1)=sum(elem_prod(elem_prod(Neq_n,exp(-0.67*Z_n(1))),Prob_talla_n*elem_prod(msex_n,colsum(Wmed_n)/nanos)));
  norteBD_end=norteBD(nanos);
  

    //-------ZONA SUR--------------------------------------- 
    // reclutas anuales a la edad 2
    for (i=1;i<=nanos;i++)
     {
	  //surN(i,1)=(1-P0)*mfexp(log_Ro+log_desv_Rt_sur(i));}
	  surN(i,1)=(1-Pr(i))*mfexp(log_Ro+log_desv_Rt_sur(i));}
      // Abundancia inicial en equilibrio
    
	//Neq_s(1)=(1-P0)*mfexp(log_Ro);
	 Neq_s(1)=(1-Pr(1))*mfexp(log_Ro);
     for (i=2;i<=nedades;i++)
     {Neq_s(i)=Neq_s(i-1)*exp(-1*M_sur);} 
     Neq_s(nedades)=Neq_s(nedades)/(1-exp(-1*M_sur));
     SSBo_s=sum(elem_prod(Neq_s*exp(-0.67*M_sur),Prob_talla_s*elem_prod(msex_s,colsum(Wmed_s)/nanos)));

    // Abundancia inicial
     for (j=2;j<=nedades;j++){
     surN(1)(j)=surN(1,j-1)*exp(-Z_s(1,j-1))*exp(log_desv_No_sur(j-1));}
     surBD(1)=sum(elem_prod(elem_prod(Neq_s,exp(-0.67*Z_s(1))),Prob_talla_s*elem_prod(msex_s,colsum(Wmed_s)/nanos)));
     surBD_end=surBD(nanos);
     SSB(1) = norteBD(1)+surBD(1);
	 
     //cout << "Prob_talla_s "<< Prob_talla_s << endl;
     //cout << "norteBD "<< norteBD << endl;
     //cout << "surBD "<< surBD << endl; exit(1);
   //-----------------------------------------------------------
     SSBo = SSBo_n+SSBo_s; //equilibrio
     //alfa=4*h*mfexp(log_Ro)/(5*h-1);// h=1
	 alfa = (SSBo*(1 - h))/(4*h*mfexp(log_Ro)); //cubillos
     //beta=(1-h)*(SSBo)/(5*h-1);// S/Reclutamiento general
	 beta = (5*h - 1)/(4*h*mfexp(log_Ro));
	 Rpred(1)=SSBo/(alfa + beta*SSBo);
	 rt(1)=norteN(1,1)+surN(1,1);
	 
   //-----------------------------------------------------------
	 for (i=2;i<=nanos;i++)
	  {
		 
	     //Rpred(i)=(norteBD(i-1)+surBD(i-1))/(alfa +beta*(norteBD(i-1)+surBD(i-1)));//relacion stock recluta
	     Rpred(i)=SSB(i-1)/(alfa +beta*SSB(i-1));
		 //-----centro-------
	     norteN(i)(1)=Pr(i)*Rpred(i)*exp(log_desv_Rt_norte(i));
	     norteN(i)(2,nedades)=++elem_prod(norteN(i-1)(1,nedades-1),S_n(i-1)(1,nedades-1));
	     norteN(i,nedades)+=norteN(i-1,nedades)*S_n(i-1,nedades);
	     norteBD(i)=sum(elem_prod(elem_prod(norteN(i),exp(-0.67*Z_n(i))),Prob_talla_n*elem_prod(msex_n,colsum(Wmed_n)/nanos)));
		 
         //cout << "norteBD "<< norteBD << endl; exit(1);
		 
		 
		 //-------sur---------
	     surN(i)(1)=(1-Pr(i))*Rpred(i)*exp(log_desv_Rt_sur(i));
	     surN(i)(2,nedades)=++elem_prod(surN(i-1)(1,nedades-1),S_s(i-1)(1,nedades-1));
	     surN(i,nedades)+=surN(i-1,nedades)*S_s(i-1,nedades);
	     surBD(i)=sum(elem_prod(elem_prod(surN(i),exp(-0.67*Z_s(i))),Prob_talla_s*elem_prod(msex_s,colsum(Wmed_s)/nanos)));
         SSB(i) = norteBD(i)+surBD(i);
		 rt(i) = norteN(i,1)+surN(i,1); //cubillos reclutamiento total
		 
	  }
	  //Reclutamiento total
      
	  //cout << "norteBD "<< norteN << endl;
      //cout << "surN "<< surN << endl;
	  
      //cout << "norteBD "<< norteBD << endl;
      //cout << "surBD "<< surBD << endl; exit(1);
 
	 


FUNCTION Eval_capturas_predichas
	
 //NORTE
 // matrices de capturas predichas por edad y año
  Cedad_n=elem_prod(elem_div(Fnorte,Z_n),elem_prod(1.-S_n,norteN));
 // matrices de capturas predichas por talla y año
  Cl_pred_n=Cedad_n*Prob_talla_n;
 // matrices de cruceros predichas por talla y año
  NM_n=elem_div(elem_prod(norteN,1-S_n),Z_n); 
  
    
  Nlcruceros_pred_n=elem_prod(NM_n,Scru_n)*Prob_talla_n; 
 // matrices de proporcion de capturas por talla y año
  pobs_n=elem_div(Cl_n,outer_prod(rowsum(Cl_n),Unos_tallas_n)+1e-5);
  ppred_n=elem_div(Cl_pred_n,outer_prod(rowsum(Cl_pred_n),Unos_tallas_n));
  
  
 // Cruceros
  pobs_cru_n=elem_div(Nlcruceros_n,outer_prod(rowsum(Nlcruceros_n),Unos_tallas_n)+1e-5);
  
  
  ppred_cru_n=elem_div(Nlcruceros_pred_n,outer_prod(rowsum(Nlcruceros_pred_n),Unos_tallas_n)+1e-5);
  
  
  
 // vectores de desembarques predichos por año
  Desemb_pred_n=rowsum((elem_prod(Cl_pred_n,Wmed_n)));
  

    
  //SUR  
 // matrices de capturas predichas por edad y año
  Cedad_s=elem_prod(elem_div(Fsur,Z_s),elem_prod(1.-S_s,surN));
 // matrices de capturas predichas por talla y año
  Cl_pred_s=Cedad_s*Prob_talla_s;
 // matrices de cruceros predichas por talla y año
  NM_s=elem_div(elem_prod(surN,1-S_s),Z_s);   
  Nlcruceros_pred_s=elem_prod(NM_s,Scru_s)*Prob_talla_s; 
 // matrices de proporcion de capturas por talla y año
  pobs_s=elem_div(Cl_s,outer_prod(rowsum(Cl_s),Unos_tallas_s)+1e-5);
  ppred_s=elem_div(Cl_pred_s,outer_prod(rowsum(Cl_pred_s),Unos_tallas_s));
 // Cruceros
  pobs_cru_s=elem_div(Nlcruceros_s,outer_prod(rowsum(Nlcruceros_s),Unos_tallas_s)+1e-5);
  ppred_cru_s=elem_div(Nlcruceros_pred_s,outer_prod(rowsum(Nlcruceros_pred_s),Unos_tallas_s)+1e-5);
 // vectores de desembarques predichos por año
  Desemb_pred_s=rowsum((elem_prod(Cl_pred_s,Wmed_s)));  
 
 


FUNCTION Eval_deinteres

 /////NORTE
 // Rutina para calcular RPR
  Nv_n=norteN;// solo para empezar los calculos
  for (int i=1;i<nanos;i++)
  {
	  Nv_n(i+1)(2,nedades)=++Nv_n(i)(1,nedades-1)*exp(-1.0*M_norte);
      Nv_n(i+1,nedades)+=Nv_n(i,nedades)*exp(-1.0*M_norte);}
  Btot_n=rowsum((elem_prod(norteN*Prob_talla_n,Wmed_n)));
  Bcru_n=rowsum((elem_prod(Nlcruceros_pred_n,Wmed_n)));;// biomasas al crucero 
  Bv_n=rowsum(elem_prod(elem_prod(NM_n,Sflo_n)*Prob_talla_n,Wmed_n));
  
  
  
  // Estimacion de B.cruceros
   qCru_n(1)=mfexp(log_qCru_n);
   qCPUE_n(1)=mfexp(log_qCPUE_n);

   for (int i=2;i<=nanos;i++)
   {qCru_n(i)=qCru_n(i-1)*mfexp(devq_n(i-1));
    qCPUE_n(i)=qCPUE_n(i-1)*mfexp(devqCPUE_n(i-1));}

   Bcrucero_pred_n=elem_prod(qCru_n,Bcru_n);
   
   
 
   SD_n=rowsum(elem_prod(elem_prod(elem_prod(norteN,exp(-0.67*Z_n))*Prob_talla_n,Wmed_n),outer_prod(Unos_anos,msex_n)));// desovantes al 1 agosto
   SDo_n=rowsum(elem_prod(elem_prod(Nv_n*exp(-0.67*M_norte)*Prob_talla_n,Wmed_n),outer_prod(Unos_anos,msex_n)));// sin pesca al 1 agosto
   
   
   //SDo2_n=sum(elem_prod(elem_prod((SDo_n*exp(-0.67*M_norte))*Prob_talla_n,msex_n),Wmed_n(nanos)));// virginal al 1 agosto     REVISARLO 9-4-25
   
   //cout << "SDo2_n"<< SDo2_n << endl;exit(1);
     
   RPR_n=elem_div(SD_n,SDo_n);
   //RPR2_n=SD_n/SDo2_n;
   CPUE_pred_n=elem_prod(qCPUE_n,Bv_n);
   
   
   //cout << "CPUE_pred_n"<< CPUE_pred_n << endl;exit(1);
  /////SUR
  // Rutina para calcular RPR
   Nv_s=surN;// solo para empezar los calculos
   for (int i=1;i<nanos;i++)
   {
 	  Nv_s(i+1)(2,nedades)=++Nv_s(i)(1,nedades-1)*exp(-1.0*M_sur);
      Nv_s(i+1,nedades)+=Nv_s(i,nedades)*exp(-1.0*M_sur);}
   Btot_s=rowsum((elem_prod(surN*Prob_talla_s,Wmed_s)));
   Bcru_s=rowsum((elem_prod(Nlcruceros_pred_s,Wmed_s)));;// biomasas al crucero 
   Bv_s=rowsum(elem_prod(elem_prod(NM_s,Sflo_s)*Prob_talla_s,Wmed_s));
   // Estimacion de B.cruceros
    qCru_s(1)=mfexp(log_qCru_s);
    qCPUE_s(1)=mfexp(log_qCPUE_s);

    for (int i=2;i<=nanos;i++)
    {qCru_s(i)=qCru_s(i-1)*mfexp(devq_s(i-1));
     qCPUE_s(i)=qCPUE_s(i-1)*mfexp(devqCPUE_s(i-1));}

    Bcrucero_pred_s=elem_prod(qCru_s,Bcru_s);
    SD_s=rowsum(elem_prod(elem_prod(elem_prod(surN,exp(-0.67*Z_s))*Prob_talla_s,Wmed_s),outer_prod(Unos_anos,msex_s)));// desovantes al 1 agosto
    SDo_s=rowsum(elem_prod(elem_prod(Nv_s*exp(-0.67*M_sur)*Prob_talla_s,Wmed_s),outer_prod(Unos_anos,msex_s)));// sin pesca al 1 agosto
    //SDo2_s=sum(elem_prod(elem_prod((SDo_s*exp(-0.67*M_sur))*Prob_talla_s,msex_s),Wmed_s(nanos)));// virginal al 1 agosto.     REVISARLO 9-4-25  
    RPR_s=elem_div(SD_s,SDo_s);
    //RPR2_s=SD_s/SDo2_s;
    CPUE_pred_s=elem_prod(qCPUE_s,Bv_s);
   
	//cout << "CPUE_pred_s"<< CPUE_pred_s << endl;exit(1);
   


FUNCTION Eval_logverosim
// esta funcion evalua el nucleo de las -log-verosimilitudes marginales para
// series con datos 0.
  int i;

  suma1=0; suma2=0; 

  for (i=1;i<=nanos;i++)
  {
   if (Bcrucero_n(i)>0){
    suma1+=square((log(Bcrucero_n(i))-log(Bcrucero_pred_n(i)))/cv1_n(i));} //cv1_n armar al igual q cv2_n
   if (CPUE_n(i)>0){
    suma2+=square((log(CPUE_n(i))-log(CPUE_pred_n(i)))/cv2_n(i));}
  }
  //cout << "suma1"<< suma1 << endl;exit(1);


  suma3=0; suma4=0; //armar suma 3 y 4

  for (i=1;i<=nanos;i++)
  {
   if (Bcrucero_s(i)>0){
    suma3+=square((log(Bcrucero_s(i))-log(Bcrucero_pred_s(i)))/cv1_s(i));} //cv1_n armar al igual q cv2_n
   if (CPUE_s(i)>0){
    suma4+=square((log(CPUE_s(i))-log(CPUE_pred_s(i)))/cv2_s(i));}
  }

  //cout << "suma4"<< suma4 << endl;exit(1);

FUNCTION Eval_funcion_objetivo

  int i,j;

///NORTE
// se calcula la F.O. como la suma de las -logver
// lognormalgraf
  likeval(1)=0.5*suma1;//Cruceros norte
  likeval(2)=0.5*suma2;//CPUE norte
  likeval(3)=0.5*suma3;//Cruceros sur
  likeval(4)=0.5*suma4;//CPUE sur 
  likeval(5)=0.5*norm2(elem_div(log(Desemb_n)-log(Desemb_pred_n),cv3_n));//Desembarques norte 
  likeval(6)=0.5*norm2(elem_div(log(Desemb_s)-log(Desemb_pred_s),cv3_s));//Desembarques sur  
  // multinomial flota
  likeval(7)=-1.*nmus_n(1)*sum(elem_prod(pobs_n,log(ppred_n)));
  likeval(8)=-1.*nmus_s(1)*sum(elem_prod(pobs_s,log(ppred_s)));
// multinomial cruceros
  likeval(9)=-1.*nmus_n(2)*sum(elem_prod(pobs_cru_n,log(ppred_cru_n)));
  likeval(10)=-1.*nmus_s(2)*sum(elem_prod(pobs_cru_s,log(ppred_cru_s)));
  
  if (active(logit_prop)){
  likeval(11)=0.5/square(0.8)*square(logit_prop);} //           NUEVO 

  //cout << "likeval"<< likeval(10) << endl;exit(1);


  // Priors
  // lognormal Ninicial y Reclutas
  //prior(1)=0.5*norm2((log(row(N,1))-log(Neq))/cvar(1));
  //prior(2)=0.5*norm2(log_desv_Rt/cvar(2));
  penalty(1)=1./(2*square(cv_Ro))*(norm2(log_desv_No_norte)+norm2(log_desv_No_sur));  
  penalty(2)=1./(2*square(cv_Ro))*(norm2(log_desv_Rt_norte)+norm2(log_desv_Rt_sur));  
  //P0
  //if(last_phase()){
  penalty(3)=0.5*norm2(log_desv_Rt_norte - log_desv_Rt_sur)/square(sigmaRR);
  //}
  
 // Penalización RW sobre las desviaciones ??
  //dvariable log_sigma_rw_Pr = log_prop;
  //dvariable sigma_rw_Pr= mfexp(log_sigma_rw_Pr);
  penalty(4)=0.0;
  if (active(dlogit_Pr)){
	  for(int i=1;i<(nanos-1);i++){
		  penalty(3) += 1.0/(2*square(cv_logitPr))*square(dlogit_Pr(i) - dlogit_Pr(i+1));
	  }
  //penalty(3)= 0.5 * norm2(dlogit_Pr) / square(sigma_rw_Pr)+ (nanos - 1) * log_sigma_rw_Pr;
  }
  //cout << "penalty3"<< penalty(3) << endl;exit(1);

  //Penalty F(1) norte
  penalty(5) = 1000*square(log_F_n(1) - mean(log_F_n)); //Cubillos
  

  
  if (active(log_k_n)){// si estima k
  prior(1)=0.5*square((log_k_n-log(parbiol_n(2)))/cvar_n(1));}
  if (active(log_k_s)){// si estima k
  prior(2)=0.5*square((log_k_s-log(parbiol_s(2)))/cvar_s(3));}
  
  if (active(log_qCru_n)){
  prior(3)=0.5*square(log_qCru_n/cvar_n(2));}
  if (active(log_qCru_s)){
  prior(4)=0.5*square(log_qCru_s/cvar_s(4));}
  
  
  if(max(opt_Sel2_n)>0){
  prior(5)=0.5*norm2(dev_log_A50f_n/cvar_n(3));}
  if(max(opt_Sel2_s)>0){
  prior(6)=0.5*norm2(dev_log_A50f_s/cvar_s(5));}
  
  if (active(log_M_n)){
  prior(7)=0.5*square((log_M_n-parbiol_n(4))/cvar_n(4));}
  if (active(log_M_s)){
  prior(8)=0.5*square((log_M_s-parbiol_s(4))/cvar_s(6));}  
  
  
  if (max(opt_devq_n)>0){
  prior(9)=0.5*norm2(devq_n/cvar_n(5));}
  
  
  if (max(opt_devq_s)>0){
  prior(10)=0.5*norm2(devq_s/cvar_s(7));}



  if (max(opt_devqCPUE_n)>0){
  prior(11)=0.5*norm2(devqCPUE_n/cvar_n(6));}
  if (max(opt_devqCPUE_s)>0){
  prior(12)=0.5*norm2(devqCPUE_s/cvar_s(8));}
  
  
  
  
  f=sum(likeval)+sum(prior)+sum(penalty);
   
   


FUNCTION Eval_CTP
	
 /////NORTE
 Sfp_n=Sflo_n(nanos);//elem_div(Unos_edad,(1+mfexp(-1.0*log(19)*(edades-mfexp(log_A50f_one))/mfexp(log_Df_one))));
 for (int j=1;j<=npbr;j++){ // pbr
  Np_n=norteN(nanos);
// Tomar una proporción estable para la proyección (último año observado)
  double Pr_proj;// último valor observado de la proporción
  Pr_proj = value(Pr(nanos));
  NMp_n=NM_n(nanos);
  Sp_n=S_n(nanos);
 
 for (int i=1;i<=nanos_proy_n;i++){
  Npplus_n=Np_n(nedades)*Sp_n(nedades);
  Np_n(2,nedades)=++elem_prod(Np_n(1,nedades-1),Sp_n(1,nedades-1));
  Np_n(nedades)+=Npplus_n;
  //cout << "Np_n"<< Np_n<< endl;exit(1);
   Np_n(1)=Pr_proj*exp(log_Ro+0.5*square(cv_Ro));//reclutas proyectados
 
  //cout << "Np_n"<< Np_n<< endl;exit(1);

  Bp_n(i,j)=sum(elem_prod(Np_n*Prob_talla_n,Wmed_n(nanos)));
  Fp_n = Sfp_n*Fpbr_n(j);
  Zp_n = Fp_n + M_norte;
  Sp_n = mfexp(-1.0*(Zp_n));
       
  NMp_n=elem_prod(Np_n,pow(Sp_n,0.67));
  SDp_n(i,j)=sum(elem_prod(NMp_n*Prob_talla_n,elem_prod(Wmed_n(nanos),msex_n)));
  Cap_n=elem_prod(elem_div(Fp_n,Zp_n),elem_prod(Np_n,(1-Sp_n)))*Prob_talla_n;
  YTP_n(i,j)=sum(elem_prod(Cap_n,Wmed_n(nanos)));
  }
  CTP_n(j)=YTP_n(1,j);
  }
 // Rutina para la estimación de RPR
 Nvp_n=Nv_n(nanos);// toma la ultima estimación
 for (int i=1;i<=nanos_proy_n;i++)
  {
      Nvplus_n=Nvp_n(nedades)*exp(-1.0*M_norte);
      Nvp_n(2,nedades)=++Nvp_n(1,nedades-1)*exp(-1.0*M_norte);
      Nvp_n(nedades)+=Nvplus_n;
      Nvp_n(1)= Pr_proj*exp(log_Ro+0.5*square(cv_Ro)); //mean(Reclutas); ////////////////////////////////////////////REVISAR
      SDvp_n(i)=sum(elem_prod((Nvp_n*exp(-0.67*M_norte))*Prob_talla_n,elem_prod(Wmed_n(nanos),msex_n)));
  }
 // mido el riesgo de RPR solo para el año proyectado de interés
 for (int i=1;i<=npbr;i++)
  {
  RPRp_n(i)=SDp_n(1,i)/SDvp_n(i);//
  }
  
  
  //////SUR
  Sfp_s=Sflo_s(nanos);//elem_div(Unos_edad,(1+mfexp(-1.0*log(19)*(edades-mfexp(log_A50f_one))/mfexp(log_Df_one))));
  for (int j=1;j<=npbr;j++){ // pbr
   Np_s=surN(nanos);
   //const dvariable Pr_proj= Pr_t(nanos);
   NMp_s=NM_s(nanos);
   Sp_s=S_s(nanos);
 
  for (int i=1;i<=nanos_proy_s;i++){
   Npplus_s=Np_s(nedades)*Sp_s(nedades);
   Np_s(2,nedades)=++elem_prod(Np_s(1,nedades-1),Sp_s(1,nedades-1));
   Np_s(nedades)+=Npplus_s;
   Np_s(1)=(1. - Pr_proj)*exp(log_Ro+0.5*square(cv_Ro)); // Reclutas proyectados

   Bp_s(i,j)=sum(elem_prod(Np_s*Prob_talla_s,Wmed_s(nanos)));

    Fp_s = Sfp_s*Fpbr_s(j);
    Zp_s = Fp_s + M_sur;
    Sp_s = mfexp(-1.0*(Zp_s));
       
   NMp_s=elem_prod(Np_s,pow(Sp_s,0.67));
   SDp_s(i,j)=sum(elem_prod(NMp_s*Prob_talla_s,elem_prod(Wmed_s(nanos),msex_s)));
   Cap_s=elem_prod(elem_div(Fp_s,Zp_s),elem_prod(Np_s,(1-Sp_s)))*Prob_talla_s;
   YTP_s(i,j)=sum(elem_prod(Cap_s,Wmed_s(nanos)));
   }
   CTP_s(j)=YTP_s(1,j);
   }
  // Rutina para la estimación de RPR
  Nvp_s=Nv_s(nanos);// toma la ultima estimación
  for (int i=1;i<=nanos_proy_s;i++)
   {
       Nvplus_s=Nvp_s(nedades)*exp(-1.0*M_sur);
       Nvp_s(2,nedades)=++Nvp_s(1,nedades-1)*exp(-1.0*M_sur);
       Nvp_s(nedades)+=Nvplus_s;
       Nvp_s(1)= (1-Pr_proj)*exp(log_Ro+0.5*square(cv_Ro));//mean(Reclutas); ////////////////////////////////////////////REVISAR
       SDvp_s(i)=sum(elem_prod((Nvp_s*exp(-0.67*M_sur))*Prob_talla_s,elem_prod(Wmed_s(nanos),msex_s)));
   }
  // mido el riesgo de RPR solo para el año proyectado de interés
  for (int i=1;i<=npbr;i++)
   {
   RPRp_s(i)=SDp_s(1,i)/SDvp_s(i);//
   }



FUNCTION Write_R

      			  adstring report_name;
      			  report_name = "For_R_cam_conjunto.rep";
      			  ofstream R_report(report_name);

      			  // Años
      			  R_report << "yrs" << endl << ano << endl;

      			  // CPUE por zona
      			  R_report << "CPUE_norte" << endl << CPUE_n << endl;
      			  R_report << "CPUE_sur"   << endl << CPUE_s   << endl;

      			  // Biomasa de crucero por zona
      			  R_report << "Bcru_norte" << endl << Bcrucero_n << endl;
      			  R_report << "Bcru_sur"   << endl << Bcrucero_s   << endl;

      			  // Biomasa total por zona
      			  R_report << "BT_norte" << endl << Btot_n << endl;
      			  R_report << "BT_sur"   << endl << Btot_s  << endl;

      			  // Biomasa desovante virgen
      			  R_report << "SSBo_n" << endl << SSBo_n << endl;
      			  R_report << "SSBo_s" << endl << SSBo_s << endl;
      			  R_report << "SSBo"   << endl << SSBo   << endl;

      			  // Captura por edad
      			  R_report << "Cedad_n" << endl << Cedad_n << endl;
      			  R_report << "Cedad_s" << endl << Cedad_s << endl;

      			  // Captura por talla predicha
      			  R_report << "Cl_pred_n" << endl << Cl_pred_n << endl;
      			  R_report << "Cl_pred_s" << endl << Cl_pred_s << endl;

      			  // Proporciones por talla
      			  R_report << "pobs_n" << endl << pobs_n << endl;
      			  R_report << "ppred_n" << endl << ppred_n << endl;
      			  R_report << "pobs_s" << endl << pobs_s << endl;
      			  R_report << "ppred_s" << endl << ppred_s << endl;

      			  // Probabilidades por talla
      			  R_report << "Prob_talla_n" << endl << Prob_talla_n << endl;
      			  R_report << "Prob_talla_s" << endl << Prob_talla_s << endl;

      			  // Biomasa desovante por zona y total
      			  R_report << "norteBD" << endl << norteBD << endl;
      			  R_report << "surBD" << endl << surBD << endl;
      			  R_report << "norteBD_end" << endl << norteBD_end << endl;
      			  R_report << "surBD_end" << endl << surBD_end << endl;
   
      			  // Tasa de explotación por zona
      			  //R_report << "Fnorte" << endl << Fnorte << endl;
      			  //R_report << "Fsur" << endl << Fsur << endl;
      			  //R_report << "F" << endl << Fmax << endl;

      			  // Reclutamiento predicho
      			  R_report << "Rpred" << endl << Rpred << endl;

      			  // Verosimilitud y mortalidad
      			  //R_report << "likeval" << endl << likeval << endl;
      			  //R_report << "m" << endl <<  M_sur << endl;

      			  // Intervalos de confianza para biomasa desovante NORTE
      			  R_report << "norteBD" << endl;  
      			  for (int i = 1; i <= nanos; i++) {
      			    dvariable mu = norteBD(i);                 // seguimos usando norteBD(i)
      			    double    sd = norteBD.sd(i);              // .sd(i) viene de sdreport_vector
      			    double    cv_i = sd / value(mu);           // convertir mu a double SOLO para calcular
      			    double    sdlog = sqrt(log(1.0 + cv_i * cv_i));
      			    double    lb = value(mu / exp(2.0 * sdlog));
      			    double    ub = value(mu * exp(2.0 * sdlog));
      			    R_report << ano(i) << " " << norteBD(i) << " " << norteBD.sd(i) << " " << lb << " " << ub << endl;
      			  }
      			  // Intervalos de confianza para biomasa desovante SUR
      			  R_report << "surBD" << endl;
      			  for (int i = 1; i <= nanos; i++) {
      			    dvariable mu = surBD(i);
      			    double    sd = surBD.sd(i);
      			    double    cv_i  = sd / value(mu);
      			    double    sdlog = sqrt(log(1.0 + cv_i * cv_i));
      			    double    lb = value(mu / exp(2.0 * sdlog));
      			    double    ub = value(mu * exp(2.0 * sdlog));
      			    // Mantiene exactamente los nombres en la salida
      			    R_report << ano(i) << " " << surBD(i) << " " << surBD.sd(i) << " " << lb << " " << ub << endl;
      			  }

      			  // Intervalos de confianza para SSB total
      			  R_report << "SSB" << endl;
      			  for (int i = 1; i <= nanos; i++) {
					  dvariable mu = SSB(i);
					  double    sd = SSB.sd(i);
					  double    cv_i  = sd / value(mu);
					  double    sdlog = sqrt(log(1.0 + cv_i * cv_i));
					  double    lb = value(mu / exp(2.0 * sdlog));
					  double    ub = value(mu * exp(2.0 * sdlog));
      			    // Mantiene exactamente los nombres en la salida
					  R_report << ano(i) << " " << SSB(i) << " " << SSB.sd(i) << " " << lb << " " << ub << endl;
				  }
      			  R_report << "Rt" << endl;
      			  for (int i = 1; i <= nanos; i++) {
					  dvariable mu = rt(i);
					  double    sd = rt.sd(i);
					  double    cv_i  = sd / value(mu);
					  double    sdlog = sqrt(log(1.0 + cv_i * cv_i));
					  double    lb = value(mu / exp(2.0 * sdlog));
					  double    ub = value(mu * exp(2.0 * sdlog));
      			    // Mantiene exactamente los nombres en la salida
					  R_report << ano(i) << " " << rt(i) << " " << rt.sd(i) << " " << lb << " " << ub << endl;
				  }
	
      			  // Intervalos de confianza para tasa de explotación
      			  // Reporte con IC lognormal 
      			  R_report << "F_max" << endl;
      			  for (int i = 1; i <= nanos; i++) {
      			    dvariable mu = Fmax(i);
      			    double    sd = Fmax.sd(i);
      			    double    cv_i  = sd / value(mu);
      			    double    sdlog = sqrt(log(1.0 + cv_i * cv_i));
      			    double    lb = value(mu / exp(2.0 * sdlog));
      			    double    ub = value(mu * exp(2.0 * sdlog));

      			    // año, valor (softmax aprox), sd, lb, ub
      			    R_report << ano(i) << " " << Fmax(i) << " " << Fmax.sd(i)
      			             << " " << lb << " " << ub << endl;
      			  }

      			  // Selectividad, peso y madurez por edad (hembras)
      			  //R_report << "lh" << endl;
      			  //for (int j = 1; j <= nedades; j++) {
      			    //R_report << j << " " << sel_h(j) << " " << w_h(j) << " " << mat_h(j) << endl;
      			 // }
			  


REPORT_SECTION
  
      report << "year" << endl;
      report << ano << endl;
	  report <<"Capturas_obs_n" << endl;
	  report << Desemb_n << endl;
	  report <<"Capturas_pred_n" << endl;
	  report << Desemb_pred_n << endl;	  	  
	  report <<"Capturas_obs_s" << endl;
	  report << Desemb_s <<endl;	
	  report <<"Capturas_pred_s" << endl;
	  report << Desemb_pred_s <<endl;		  	  
  // CPUE por zona
      report << "CPUE_obs_n" << endl;
	  report << CPUE_n << endl;
      report << "CPUE_pred_n" << endl;
	  report << CPUE_pred_n << endl;
      report << "CPUE_obs_s"   << endl;
	  report << CPUE_s   << endl;
      report << "CPUE_pred_s"   << endl;
	  report << CPUE_pred_s   << endl;
      // Biomasa de crucero por zona
      report << "Crucero_obs_n" << endl;
	  report << Bcrucero_n << endl;
      report << "Crucero_pred_n" << endl;
	  report << Bcrucero_pred_n << endl;
      report << "Crucero_obs_s"   << endl;
	  report << Bcrucero_s   << endl;
      report << "Crucero_pred_s"   << endl;
	  report << Bcrucero_pred_s   << endl;
    // Biomasa total por zona
      report << "BT_norte" << endl;
      report << Btot_n << endl;
      report << "BT_sur"   << endl;
      report << Btot_s  << endl;  
      report << "norteBD" << endl; 
	  report << norteBD << endl;
      report << "surBD" << endl;
	  report << surBD << endl;
      report << "norteBD_end" << endl;
	  report << norteBD_end << endl;
      report << "surBD_end" << endl;
	  report << surBD_end << endl;
  // Biomasa desovante virgen	  
	  report << "SSBo_n" << endl;
      report << SSBo_n << endl;  
	  report << "SSBo_s" << endl;
	  report << SSBo_s << endl;
	  report << "SSBo" << endl;
	  report << SSBo << endl;
	  report << "norteN" << endl;
	  report << norteN << endl;
	  report << "surN" << endl;
	  report << surN << endl;
  // Captura por edad
	  report << "Cedad_n" << endl;
	  report << Cedad_n << endl;
	  report << "Cedad_s" << endl;
	  report << Cedad_s << endl;
  // Captura por talla predicha  
	  report << "Cl_pred_n" << endl;
	  report << Cl_pred_n << endl;
	  report << "Cl_pred_s" << endl;
	  report << Cl_pred_s << endl;
	  report << "Fnorte" << endl;
	  report << Fnorte << endl;
	  report << "Fsur" << endl;
	  report << Fsur << endl;
      report <<"F_n" << endl;
	  report << Flast_norte << endl;
	  report <<"F_s" << endl;
      report << Flast_sur << endl;
	  
	  
	  report << "Rpred" << endl;
	  report << Rpred << endl;
	 
   // Proporciones por talla
	  report << "pobs_n" << endl;
	  report << pobs_n << endl;
	  report << "ppred_n" << endl;
	  report << ppred_n << endl;
	  report << "pobs_s" << endl;
	  report << pobs_s << endl;
	  report << "ppred_s" << endl;
	  report << ppred_s << endl;
	  report << "pobs_cru_n" << endl;
	  report << pobs_cru_n << endl;
	  report << "ppred_cru_n" << endl;
	  report << ppred_cru_n << endl;
	  report << "pobs_cru_s" << endl;
	  report << pobs_cru_s << endl;
	  report << "ppred_cru_s" << endl;
	  report << ppred_cru_s << endl;
	  report << "Sflo_n" << endl;
	  report << Sflo_n << endl;
	  report << "Sflo_s" << endl;
	  report << Sflo_s << endl;
	  report << "Scru_n" << endl;
	  report << Scru_n << endl;
	  report << "Scru_s" << endl;
	  report << Scru_s << endl;
	 
	  report << "Z_n" << endl;
	  report << Z_n << endl;
	  report << "Z_s" << endl;
	  report << Z_s << endl;
	  report << "S_n" << endl;
	  report << S_n << endl;
	  report << "S_s" << endl;
	  report << S_s << endl;
	  report << "Prob_talla_n" << endl;
	  report << Prob_talla_n << endl;
	  report << "Prob_talla_s" << endl;
	  report << Prob_talla_s << endl;
	  report << "norteBD_end" << endl;
	  report << norteBD_end << endl;
	  report << "surBD_end" << endl;
	  report << surBD_end << endl;
	  report << "Lf_obs_n" << endl;
	  report << Tallas_n*trans(pobs_n)<< endl;
	  report << "Lf_pred_n" << endl;
	  report << Tallas_n*trans(ppred_n)<< endl;
	  report << "Lc_obs_n" << endl;
	  report << Tallas_n*trans(pobs_cru_n)<< endl;
	  report << "Lc_pred_n" << endl;
	  report << Tallas_n*trans(ppred_cru_n)<< endl;
	  report << "Lf_obs_s" << endl;
	  report << Tallas_s*trans(pobs_s)<< endl;
	  report << "Lf_pred_s" << endl;
	  report << Tallas_s*trans(ppred_s)<< endl;
	  report << "Lc_obs_s" << endl;
	  report << Tallas_s*trans(pobs_cru_s)<< endl;
	  report << "Lc_pred_s" << endl;
	  report << Tallas_s*trans(ppred_cru_s)<< endl;
	  // Serie de proporción anual
	  report << "Pr" << endl;
	  report << Pr << endl;
	 // Parámetros del suavizado
	  report << "logit_prop" << endl;
	  report << logit_prop << endl;
	  report << "qCPUE_n" << endl;
	  report << qCPUE_n << endl;
	  report << "qCPUE_s" << endl;
	  report << qCPUE_n << endl;
	  report << "qCru_n" << endl;
	  report << qCru_n << endl;
	  report << "qCru_s" << endl;
	  report << qCru_s << endl;
	  
	  // Resumen
	  report << "Pr_eq" << endl;
	  report << Pr_t(1) << endl;
	  report << "Pr_last" << endl;
	  report << Pr_t(nanos) << endl;
	  report << "Pr_mean" << endl;
	  report << mean(Pr_t) << endl;	  
	
	  report << "likeval" << endl;
	  report << likeval << endl;
	  report << "Penalty" << endl;
	  report << penalty << endl;
	  report << "prior" << endl;
	  report << prior << endl;
	
  
	  
 
FUNCTION Eval_mcmc
  if(reporte_mcmc == 0)
  mcmc_report<<"Bcru CTP1 CTP2 CTP3 CTP4 CTP5 BDp1_fin BDp2_fin BDp3_fin BDp4_fin BDp5_fin"<<endl;
  mcmc_report<<Bcrucero_pred_n(nanos)<<" "<<YTP_n(1,1)<<" "<<YTP_n(1,2)<<" "<<YTP_n(1,3)<<" "<<YTP_n(1,4)<<" "<<YTP_n(1,5)<<
     " "<<SDp_n(nanos_proy_n,1)<<" "<<SDp_n(nanos_proy_n,2)<<" "<<SDp_n(nanos_proy_n,3)<<
     " "<<SDp_n(nanos_proy_n,4)<<" "<<SDp_n(nanos_proy_n,5)<<endl;

  reporte_mcmc++;
  

GLOBALS_SECTION
  #include  <admodel.h>
  ofstream mcmc_report("mcmc.txt");
