GLOBALS_SECTION
 #include <admodel.h>
 #include <stdio.h>
 #include <time.h>
 #include <string.h>
 time_t start,finish;
 long hour,minute,second;
 double elapsed_time;
 bool mcmcPhase = 0;
 bool mcmcEvalPhase = 0;

 ofstream mcmc_report("mcmc.csv");
 #undef reporte
 #define reporte(object) report << #object "\n" << object << endl;
 #undef R_Report
 #define R_Report(object) R_report << #object "\n" << object << endl;
 
  //MODIFICACIONES 
  adstring simname;
  //Nombre de archivo gradiente
  ofstream rep_grad("00rep_convergencia.txt",ios::app);
  ofstream rep1("01Capturas_proyectadas.txt",ios::app);
  ofstream rep2("02BiomasaTotal_op.txt",ios::app);
  ofstream rep3("03Desovante_op.txt",ios::app);
  ofstream rep4("04Reclutamiento_op.txt",ios::app);
  ofstream rep5("05FMort_op.txt",ios::app);
  //Nombre de archivos para las variables de estado del estimador
  ofstream rep6("02BiomasaTotal_est.txt",ios::app);
  ofstream rep7("03Desovante_est.txt",ios::app);
  ofstream rep8("04Reclutamiento_est.txt",ios::app);
  ofstream rep9("05FMort_est.txt",ios::app);
  //Nombre de archivos para fase histórica del simulador agregado por LCubillos
  ofstream rep10("07Fmort_hist.txt",ios::app);
  ofstream rep11("08Desovante_hist.txt",ios::app);
  ofstream rep12("09BiomTotal_hist.txt",ios::app);
  ofstream rep13("10Reclutas_hist.txt",ios::app); 
  ofstream rep14("11RPR_est.txt",ios::app);   
  ofstream rep15("12RPR_op.txt",ios::app);  
  ofstream rep16("12RPR_hist.txt",ios::app); 
  ofstream rep17("13Bcru_op.txt",ios::app); 
  
  
  
  /*
  //Nombre de archivos para las variables de estado del simulador 
  ofstream rep1("01Desovante_sim.txt",ios::app);
  ofstream rep2("02Reclutamiento_sim.txt",ios::app);
  ofstream rep3("03FMort_sim.txt",ios::app);
  ofstream rep4("01Desovente_est.txt",ios::app);
  ofstream rep5("02Reclutamiento_est.txt",ios::app);
  ofstream rep6("03Fmort_est.txt",ios::app);
  ofstream rep7("04So_sim.txt",ios::app);
  ofstream rep8("05RPR_sim.txt",ios::app);
  ofstream rep9("04So_est.txt",ios::app);
  ofstream rep10("05RPR_est.txt",ios::app);
  */
 
  #if defined(WIN32) && !defined(__linux__)
  const char* PLATFORM = "Windows";
  #else
  const char* PLATFORM = "MAC";
  #endif

  adstring BaseFileName;
  adstring ReportFileName;
  //adstring ResultsPath;
  adstring stripExtension(adstring fileName)
  {
  /* from Stock-Sintesis */
  const int length = fileName.size();
  for (int i=length; i>=0; --i)
  {
	if (fileName(i)=='.')
	{
		return fileName(1,i-1);
	}
  }
  return fileName;
  }
 

TOP_OF_MAIN_SECTION
 time(&start);
 arrmblsize = 50000000; 
 gradient_structure::set_GRADSTACK_BUFFER_SIZE(1.e7); 
 gradient_structure::set_CMPDIF_BUFFER_SIZE(1.e7); 
 gradient_structure::set_MAX_NVAR_OFFSET(5000); 
 gradient_structure::set_NUM_DEPENDENT_VARIABLES(5000); 

DATA_SECTION
  
  int iseed // generador de numeros aleatorios 
  !!long int lseed=iseed;
  !!CLASS random_number_generator rng(iseed);
  
  //se ancla al archivo .dat que guia a los datos
  init_adstring DataFile;
  init_adstring ControlFile;
  //init_adstring ResultsFileName;

  !! BaseFileName = stripExtension(ControlFile);
  //verificar este leyendo bien los datos de entrada 
  !! cout << "dat: " << " " << DataFile << endl;
  !! cout << "ctl: " << " " << ControlFile << endl;
  !! cout << "basefileName: " << " " << BaseFileName << endl;
  !! ReportFileName = BaseFileName + adstring(".rep");
   // !! ResultsPath = stripExtension(ResultsFileName);
   // !! depur(ReportFileName)
   // !! depuro(ResultsPath)
  !! ad_comm::change_datafile_name(DataFile);
  	
	
 init_int nyears 
 init_int nedades
 init_int ntallas

 init_matrix data(1,nyears,1,13);
  //Years/desem/cpue/Bcru/ph/cv_desem/cv_CPUE/cv_Cru/cv_ph/n_mf/n_hf/n_mc/n_hc
 init_vector vec_ages(1,nedades);
 init_vector vec_tallas(1,ntallas);

 init_3darray Catsize(1,4,1,nyears,1,ntallas);
 //!! ad_comm::change_datafile_name("control_s.ctl");
 !! ad_comm::change_datafile_name(ControlFile);
 init_vector msex(1,ntallas);
 init_matrix Wmed(1,2,1,ntallas);
 init_vector cvar(1,3);//# Coeficiente de variación de los desvios Rt, No y prop_machos en el Reclutamiento
 init_vector dt(1,3);
 
 init_matrix Par_bio(1,2,1,5); //#Loo, k, Lt(a=1), cv(edad), M; filas machos,hembras y prior si se estiman
 init_vector cv_priors(1,5);

  number log_Lopriorm
  number log_Lopriorh
  !! log_Lopriorm = log(Par_bio(1,3));
  !! log_Lopriorh = log(Par_bio(2,3));

  number log_cva_priorm
  number log_cva_priorh
  !! log_cva_priorm = log(Par_bio(1,4));
  !! log_cva_priorh = log(Par_bio(2,4));

  number log_M_priorm
  number log_M_priorh
  !! log_M_priorm = log(Par_bio(1,5));
  !! log_M_priorh = log(Par_bio(2,5));

 init_number h
 
 init_number qcru
 init_number cv_qcru

  number log_qcru_prior
  !! log_qcru_prior = log(qcru);


 init_matrix sel_ini(1,4,1,2);//Selectividad flota y crucero (valores de partida y rango)


 // Priors para selectividades y sd
 //Flota
 number log_L50fpriorm
 !! log_L50fpriorm = log(sel_ini(1,1));

 number log_s1priorm
 !! log_s1priorm = log(sel_ini(1,2));


 number log_L50fpriorh
 !! log_L50fpriorh = log(sel_ini(2,1));
 
 number log_s1priorh
 !! log_s1priorh = log(sel_ini(2,2));
 
 
//Crucero
number log_L50cpriorm
!! log_L50cpriorm = log(sel_ini(3,1));

number log_s1priorcm
!! log_s1priorcm = log(sel_ini(3,2));


 number log_L50cpriorh
 !! log_L50cpriorh = log(sel_ini(4,1));
 
 number log_s1priorch
 !! log_s1priorch = log(sel_ini(4,2));
 



 init_int    nbloq_selflo
 init_vector ybloq_selflo(1,nbloq_selflo);

 init_int    nbloq_selcru
 init_vector ybloq_selcru(1,nbloq_selcru);

 init_int    nbloq_qflo
 init_vector ybloq_qflo(1,nbloq_qflo);

 init_int    nbloq_qcru
 init_vector ybloq_qcru(1,nbloq_qcru);

// Fases de estimacion
 init_int    phs_qflo  // q flota
 init_int    phs_qcru  // q crucero

 init_int    phs_Selflo //fase sel flo
 init_int    phs_Selcru //fase sel cru

 init_int    phs_Lo
 init_int    phs_cva
 init_int    phs_M //no se estima

 init_int    phs_F
 init_int    phs_devRt
 init_int    phs_devNo
 init_int    phs_prop_mR
 init_int    phs_Fpbr


 // Lee numero y tasas de pbr
 init_int    npbr
 init_vector tasa_bdpr(1,npbr);

  // Simulaciones
 init_int nyear_proy
 init_number pRec // Proporción de Reclutamiento para Proyección de capturas ante distintos niveles (1.0 proporcional al reclutamiento medio)
 init_number opt_sim // Opción para simular o estimar(0=simula, 1=estima)
 init_int simcomptalla
 init_int hyper	 
 int reporte_mcmc


INITIALIZATION_SECTION

  log_Lom        log_Lopriorm // Inicializo log_Lom con log_Lopriorm, luego se estima en el modelo y toma otro valor
  log_Loh        log_Lopriorh
  
  log_cv_edadm   log_cva_priorm // Parbio = 0.1
  log_cv_edadh   log_cva_priorh
  
  log_propmR        -0.69314 // 0.5 en escala normal


  log_L50flom        log_L50fpriorm 
  log_L50floh        log_L50fpriorh 
    
  log_sdL50flomL     log_s1priorm 


  log_sdL50flohL     log_s1priorh 


  log_L50crum        log_L50cpriorm 
  log_L50cruh        log_L50cpriorh 
  
  log_sdL50crumL     log_s1priorcm 
  

  log_sdL50cruhL     log_s1priorch 



  log_Mm           log_M_priorm
  log_Mh           log_M_priorh


PARAMETER_SECTION


// selectividad paramétrica a la talla común
// init_bounded_vector log_L50f(1,nbloq_selflo,-5,8,opt1_fase)  

// init_3darray log_sel_inif(1,2,1,2,1,nbloq_selflo,phs_Selflo)

 init_vector log_L50flom(1,nbloq_selflo,phs_Selflo);// Podría ser bounded (0.67,1.94)
 init_vector log_sdL50flomL(1,nbloq_selflo,phs_Selflo);


 init_vector log_L50floh(1,nbloq_selflo,phs_Selflo);// Podría ser bounded (0.67,1.94)
 //init_vector log_sdL50flohL(1,nbloq_selflo,phs_Selflo);
 init_bounded_vector log_sdL50flohL(1,nbloq_selflo,0.5*log_s1priorh,1.2*log_s1priorh,phs_Selflo)
 

 init_bounded_vector log_L50cruh(1,nbloq_selcru,0.7,1.1,phs_Selcru);// Podría ser bounded (0.67,1.94)
 init_bounded_vector log_sdL50cruhL(1,nbloq_selcru,-0.15,-0.09,phs_Selcru);
 

 init_bounded_vector log_L50crum(1,nbloq_selcru,1.2,1.7,phs_Selcru);// Podría ser bounded (0.67,1.94)
 init_bounded_vector log_sdL50crumL(1,nbloq_selcru,0.7,1.1,phs_Selcru);
 


// parametros reclutamientos, desvíos R, No y mortalidades)
 init_number log_Ro(1);// Inicializado en que valor..(0)??? (En fase 1)
 init_bounded_number log_propmR(-2.3,-0.1,phs_prop_mR); // prop de machos en el reclutamiento (comienza en el valor medio entre 0.1 y 0.9, es decir 0.5)
 init_bounded_dev_vector log_dev_Ro(1,nyears,-10,10,phs_devRt); //dev_vector para que la suma de los parámetros al ser estimados sea 0
 init_bounded_vector log_dev_Nom(1,nedades,-10,10,phs_devNo); // -10, 10 significa...
 init_bounded_vector log_dev_Noh(1,nedades,-10,10,phs_devNo);
 init_bounded_vector log_Fm(1,nyears,-20,1,phs_F); // // log  mortalidad por pesca por flota machos F LIMITADA EN 0.8187 !!!!!!
 init_bounded_vector log_Fh(1,nyears,-20,1,phs_F); // log  mortalidad por pesca por flota

// capturabilidades
 init_vector log_qflo(1,nbloq_qflo,phs_qflo);
 init_vector log_qcru(1,nbloq_qcru,phs_qcru);

// Crecimiento
 init_number log_Lom(phs_Lo);
 init_number log_cv_edadm(phs_cva);

 init_number log_Loh(phs_Lo);
 init_number log_cv_edadh(phs_cva);

 // Mortalidad Natural
 init_number log_Mh(phs_M);//EL valor inicial es negativo por tanto no se estima
 init_number log_Mm(phs_M);

// Fpbr
 init_vector log_Fref(1,npbr,phs_Fpbr); // F referencias para los PBRs

//VARIABLES
//Defino las variables de estado 
 vector BMflo(1,nyears);
 vector BMcru(1,nyears);

 vector likeval(1,20); //Numero de funciones objetivo (1,20)
 vector Neqm(1,nedades);
 vector Neqh(1,nedades);

 vector Rpred(1,nyears);
 vector Unos_edad(1,nedades);
 vector Unos_yrs(1,nyears);
 vector Unos_tallas(1,ntallas);
 vector mu_edadm(1,nedades);
 vector mu_edadh(1,nedades);
 vector sigma_edadm(1,nedades);
 vector sigma_edadh(1,nedades);
 vector BDo(1,nyears);
 vector No(1,nedades);

 vector yrs(1,nyears);
 vector Desemb(1,nyears);
 vector CPUE(1,nyears);
 vector Bcru(1,nyears);
 vector prop_h(1,nyears);
 vector prop_hpred(1,nyears);

 matrix cv_index(1,4,1,nyears);
 matrix nm_flocru(1,4,1,nyears);

 matrix S_flom(1,nbloq_selflo,1,nedades);
 matrix S_floh(1,nbloq_selflo,1,nedades);
 matrix S_crum(1,nbloq_selcru,1,nedades);
 matrix S_cruh(1,nbloq_selcru,1,nedades);

 matrix Sel_flom(1,nyears,1,nedades);
 matrix Sel_floh(1,nyears,1,nedades);
 matrix Sel_crum(1,nyears,1,nedades);
 matrix Sel_cruh(1,nyears,1,nedades);

 matrix Fm(1,nyears,1,nedades);
 matrix Fh(1,nyears,1,nedades);
 matrix Zm(1,nyears,1,nedades);
 matrix Zh(1,nyears,1,nedades);
 
 matrix Sm(1,nyears,1,nedades);
 matrix Sh(1,nyears,1,nedades);
 matrix Nm(1,nyears,1,nedades);
 matrix Nh(1,nyears,1,nedades);

 matrix NMD(1,nyears,1,ntallas);
 matrix NDv(1,nyears,1,ntallas);

 matrix NVflo_m(1,nyears,1,ntallas);
 matrix NVflo_h(1,nyears,1,ntallas);
 matrix NVcru_m(1,nyears,1,ntallas);
 matrix NVcru_h(1,nyears,1,ntallas);

 matrix pred_Ctot_am(1,nyears,1,nedades);
 matrix pred_Ctotm(1,nyears,1,ntallas);
 matrix pred_Ctot_ah(1,nyears,1,nedades);
 matrix pred_Ctoth(1,nyears,1,ntallas);

 matrix pobs_flom(1,nyears,1,ntallas);
 matrix ppred_flom(1,nyears,1,ntallas);
 matrix pobs_floh(1,nyears,1,ntallas);
 matrix ppred_floh(1,nyears,1,ntallas);

 matrix pobs_crum(1,nyears,1,ntallas);
 matrix ppred_crum(1,nyears,1,ntallas);
 matrix pobs_cruh(1,nyears,1,ntallas);
 matrix ppred_cruh(1,nyears,1,ntallas);

 matrix Prob_talla_m(1,nedades,1,ntallas);
 matrix Prob_talla_h(1,nedades,1,ntallas);

 matrix Nv(1,nyears,1,nedades);

 number suma1
 number suma2
 number suma3
 number suma4
 number suma5
 number suma6
 number suma7

 number penalty

 number alfa
 number beta

 number Linfm
 number K_m
 number Linfh
 number K_h

 number Mm
 number Mh

 number BDp
 number Npplus
 number Bph
 number Bpm
 
 number nm1
 number cuenta1
 number nm2
 number cuenta2
 number nm3
 number cuenta3
 number nm4
 number cuenta4
	 number Prm //Cubillos

 vector Nph(1,nedades);
 vector Zpbrh(1,nedades);
 vector Fpbrh(1,nedades);
 vector Sph(1,nedades);
 vector Npm(1,nedades);
 vector Zpbrm(1,nedades);
 vector Fpbrm(1,nedades);
 vector Spm(1,nedades);

 vector CTP(1,ntallas);
 vector Ctp(1,npbr);
 vector NMDp(1,ntallas);
 matrix YTP(1,nyear_proy,1,npbr);
 matrix BTp(1,nyear_proy,1,npbr);

 number BD_lp
 vector ratio_pbr(1,npbr);

 vector Nvp(1,nedades);
 number Nvplus;
 vector SDvp(1,nyear_proy);

 vector CBA(1,npbr);

 objective_function_value f
 
 sdreport_vector pred_CPUE(1,nyears);
 sdreport_vector pred_Bcru(1,nyears);
 sdreport_vector pred_Desemb(1,nyears);
 
 sdreport_vector BD(1,nyears);
 sdreport_vector BT(1,nyears);
 sdreport_vector BV(1,nyears);
 sdreport_vector RPRlp(1,nyears);
 sdreport_number SSBo
 
 vector RPRp(1,npbr); // RPR proyectado en la simulacion
 //sdreport_vector Restim(1,nyears);//Reclutas hembras
 vector RPR(1,nyears);
 //sdreport_matrix SSBp(1,nyear_proy,1,npbr);//Biomasa desovante proyectada
 
 vector Lmf_obs(1,nyears);
 sdreport_vector Lmf_pred(1,nyears);
 vector Lhf_obs(1,nyears);
 sdreport_vector Lhf_pred(1,nyears);
 vector Lmc_obs(1,nyears);
 sdreport_vector Lmc_pred(1,nyears);
 vector Lhc_obs(1,nyears);
 sdreport_vector Lhc_pred(1,nyears);
 sdreport_vector Frpr(1,nyears);
 
 //simulador
 
 matrix sim_p_len_f_m(1,nyears,1,ntallas);
 matrix sim_p_len_cru_m(1,nyears,1,ntallas);
 matrix sim_p_len_f_h(1,nyears,1,ntallas);
 matrix sim_p_len_cru_h(1,nyears,1,ntallas);
 vector sim_Bcru(1,nyears);
 vector sim_CPUE(1,nyears);
 vector sim_prop_h(1,nyears);
 vector Rest(1,nyears);
 //vector keep_SSBt(1,nyears);
 //vector keep_Rt(1,nyears);
 //vector keep_Ft(1,nyears);
 //vector keep_rpr(1,nyears);
 //number keep_so;
 
 //Section Operating model
  number log_q_cru_fut;
  number log_q_cpue_fut;
  vector pm(1,nedades);
  vector wtm(1,nedades);
  vector wth(1,nedades);
  vector Nfut_m(1,nedades);
  vector Nfut_h(1,nedades);
  vector Sfut_m(1,nedades);
  vector Sfut_h(1,nedades);
  vector Zfut_m(1,nedades);
  vector Zfut_h(1,nedades);
  vector Sfutflo_m(1,nedades);
  vector Sfutflo_h(1,nedades);
  vector Sfutcru_m(1,nedades);
  vector Sfutcru_h(1,nedades);
  vector rec_epsilon(nyears+1,nyears+nyear_proy);
  vector cru_epsilon(nyears+1,nyears+nyear_proy);
  vector cpue_epsilon(nyears+1,nyears+nyear_proy);
  matrix Rfut(1,npbr,nyears+1,nyears+nyear_proy);
  vector sel(1,nedades);
  number BDfut;
  number qfut_flo;
  number qfut_cru;
  vector NVfutflo_h(1,ntallas);
  vector NVfutflo_m(1,ntallas);
  vector NVfutcru_h(1,ntallas);
  vector NVfutcru_m(1,ntallas);
  number BMfut_flo_m;
  number BMfut_flo_h;
  number BMfut_flo
  number BMfut_cru_m;
  number BMfut_cru_h;
  number BMfut_cru;
  number BTfut_m;
  number BTfut_h;
  vector bcru_fut(nyears+1,nyears+nyear_proy); //time
   matrix C_fut(1,npbr,nyears+1,nyears+nyear_proy); //matrix npbr time
   matrix Fm_fut(nyears+1,nyears+nyear_proy,1,nedades); // time edad
   matrix Fh_fut(nyears+1,nyears+nyear_proy,1,nedades); // time edad
   vector Fyr_fut(nyears+1,nyears+nyear_proy); //time
   vector cpue_fut(nyears+1,nyears+nyear_proy); //time
   vector ssb_fut(nyears+1,nyears+nyear_proy); //time
   vector BTfut(nyears+1,nyears+nyear_proy); //time
   matrix catage_m(nyears+1,nyears+nyear_proy,1,nedades); //nedades
   matrix catage_h(nyears+1,nyears+nyear_proy,1,nedades); //nedades
   matrix catlen_m(nyears+1,nyears+nyear_proy,1,ntallas); // times tallas
   matrix catlen_h(nyears+1,nyears+nyear_proy,1,ntallas); // times tallas
   matrix fut_pflo_m(nyears+1,nyears+nyear_proy,1,ntallas); //times tallas
   matrix fut_pflo_h(nyears+1,nyears+nyear_proy,1,ntallas); //times tallas
   matrix fut_pcru_m(nyears+1,nyears+nyear_proy,1,ntallas); // times talla
   matrix fut_pcru_h(nyears+1,nyears+nyear_proy,1,ntallas); // times talla
   vector prop_h_fut(nyears+1,nyears+nyear_proy);
   vector bvuln_fut(nyears+1,nyears+nyear_proy);
   vector yrs_fut(nyears+1,nyears+nyear_proy);
   number ytp;
   number mu_ref;
   number Kobs_tot_catch;
   matrix F_tmp(nyears+1,nyears+nyear_proy,1,nedades);
   number M_tmp;
   vector Fyr(1,nyears);
   matrix keep_Btot(1,npbr,nyears+1,nyears+nyear_proy);//biomasa total 
   matrix keep_SSBt(1,npbr,nyears+1,nyears+nyear_proy);//biomasa desovante
   matrix keep_Rt(1,npbr,nyears+1,nyears+nyear_proy); //Reclutamiento
   matrix keep_Ro(1,npbr,nyears+1,nyears+nyear_proy); 
   matrix keep_Ft(1,npbr,nyears+1,nyears+nyear_proy);//mortalidad por pesca
   //Guarda las cantidades equivalentes del MOP
   matrix des_Btot(1,npbr,nyears+1,nyears+nyear_proy); 
   matrix des_SSBt(1,npbr,nyears+1,nyears+nyear_proy);
   matrix des_Rt(1,npbr,nyears+1,nyears+nyear_proy);
   matrix des_Ro(1,npbr,nyears+1,nyears+nyear_proy);
   matrix des_F(1,npbr,nyears+1,nyears+nyear_proy);
   matrix RPRfut(1,npbr,nyears+1,nyears+nyear_proy);
   matrix check_convergence(1,npbr,nyears+1,nyears+nyear_proy);
   
  

PRELIMINARY_CALCS_SECTION

 yrs=column(data,1);
 Desemb=column(data,2);
 CPUE=column(data,3);
 Bcru=column(data,4);
 prop_h=column(data,5);

 for (int i=1;i<=4;i++){
 cv_index(i)=column(data,i+5);
 nm_flocru(i)=column(data,i+9);
 }

 Linfm=Par_bio(1,1);
 K_m=Par_bio(1,2);
 Linfh=Par_bio(2,1);
 K_h=Par_bio(2,2);
 // Mm=Par_bio(1,5);
 // Mh=Par_bio(2,5);

 Unos_edad=1;// lo uso en  operaciones matriciales con la edad
 Unos_yrs=1;// lo uso en operaciones matriciales con el año
 Unos_tallas=1;// lo uso en operaciones matriciales con el año


  reporte_mcmc=0;


RUNTIME_SECTION
 // maximum_function_evaluations 500,2000,5000
 //convergence_criteria  1e-2,1e-5,1e-5

 // tomado de AMAK (Ianelli)
//  convergence_criteria 1.e-1,1.e-01,1.e-03,1e-5,1e-5

  convergence_criteria 1.e-1,1.e-02,1.e-03,1e-4,1e-5
  maximum_function_evaluations 100,100,200,300,3500

PROCEDURE_SECTION
// se listan las funciones que contienen los calculos
 Eval_prob_talla_edad();
 Eval_selectividad();
 Eval_mortalidades();
 Eval_abundancia();
 Eval_deinteres();
 Eval_biomasas();
 Eval_capturas_predichas();
 Eval_indices();
 Eval_PBR();
 Eval_logverosim();
 Eval_funcion_objetivo();

  //if(last_phase()){
  //	 Eval_CTP();
  //   Eval_mcmc();
  //}
     //if(mc_phase()){mcmcPhase=1;}
     if(mceval_phase()){
   	 // mcmcEvalPhase=1;
   	 // Sim_data();
   	Operative_model(); 
  }

 //FINAL_SECTION
	//cout << "aqui comienza Operative Model" << endl;exit(1);
  	//Operative_model();

	/*      
 Sim_data(); //Cubillos: desactivar y activar modo mcmc
 //Write_R();
 if(strcmp(PLATFORM,"MAC")==0)
 {
 adstring bscmd = "cp Lam_op.rep " +ReportFileName;
 system(bscmd);
 bscmd = "cp Lam_op.par " + BaseFileName + ".par";
 system(bscmd);  
 bscmd = "cp Lam_op.std " + BaseFileName + ".std";
 system(bscmd);		 
 bscmd = "cp Lam_op.cor " + BaseFileName + ".cor";
 system(bscmd);		 
 bscmd = "cp Lam_op.cor " + BaseFileName + ".cor";
 system(bscmd);		 
 //bscmd = "cp For_R_lac_sur.rep" + BaseFileName + ".rep";
 //system(bscmd); 
 if( mcmcPhase==1 )
 {
 bscmd = "cp Lm_op.psv " + BaseFileName + ".psv";
 system(bscmd);	
 cout<<"Copia de archivo binario de valores muestrales posterior"<<endl;
 }}
 if(strcmp(PLATFORM,"Windows")==0)
 {
 adstring bscmd = "copy Lm_op.rep " +ReportFileName;
 system(bscmd);
 bscmd = "copy Lam_op.par " + BaseFileName + ".par";
 system(bscmd); 
 bscmd = "copy Lam_op.std " + BaseFileName + ".std";
 system(bscmd);
 bscmd = "copy Lam_op.cor " + BaseFileName + ".cor";
 system(bscmd);
 bscmd = "copy Lam_op.cor " + BaseFileName + ".cor";
 system(bscmd);
//bscmd = "copy For_R_lac_sur.rep" + BaseFileName + ".rep";
 //system(bscmd);
 if( mcmcPhase==1 )
 {
 bscmd = "copy Lam_op.psv " + BaseFileName + ".psv";
 system(bscmd);
 cout<<"Copia de archivo binario de valores muestrales posterior"<<endl;
 }}

    time(&finish);
    elapsed_time=difftime(finish,start);
    hour=long(elapsed_time)/3600;
    minute=long(elapsed_time)%3600/60;
    second=(long(elapsed_time)%3600)%60;
    cout<<endl<<endl<<"*********************************************"<<endl;
    cout<<"--Start time:  "<<ctime(&start)<<endl;
    cout<<"--Finish time: "<<ctime(&finish)<<endl;
    cout<<"--Runtime: ";
    cout<<hour<<" hours, "<<minute<<" minutes, "<<second<<" seconds"<<endl;
	cout<<endl<<"RESULTADOS:"<<endl;
	cout << "dat: " << " " << DataFile << endl;
	cout << "ctl: " << " " << ControlFile << endl;
	cout << "basefileName: " << " " << BaseFileName << endl;
    cout<<"*********************************************"<<endl;
	  
 */


FUNCTION Operative_model
	
	log_q_cru_fut = log_qcru(nbloq_qcru);
    log_q_cpue_fut = log_qflo(nbloq_qflo);
	//cout << "log_q_cpue_fut " << log_q_cpue_fut << endl;exit(1);
	pm = Prob_talla_h*msex;
	wtm = Prob_talla_m*Wmed(1);
	wth = Prob_talla_h*Wmed(2);
	//cout << "wth " << wth << endl;exit(1);
	dvector ran_rec(nyears+1,nyears + nyear_proy);
	dvector ran_cru(nyears+1,nyears + nyear_proy);
	dvector ran_cpue(nyears+1,nyears + nyear_proy);
	int upk;
	int i,j,k,l,a;
	dvariable numyear = 1985;
	dvector yrs(nyears+1,nyears + nyear_proy);
	simname = "Lam.dat";
	dvector CatchNow(1,npbr);
	dvector eval_now(1,5);
	dvariable grad_tmp;
	
	ran_rec.fill_randn(rng);
	ran_cru.fill_randn(rng);
	int rv;
	//cout << "yrs " << yrs << endl;exit(1);
	
	for(int l=1;l <= npbr;l++){
		rv=system("./paso1.sh");
		Nfut_m = Nm(nyears);
		Nfut_h = Nh(nyears);
		Sfut_m = Sm(nyears);
		Sfut_h = Sh(nyears);
		Zfut_m = Zm(nyears);
		Zfut_h = Zh(nyears);
		Sfutflo_m = Sel_flom(nyears);
		Sfutflo_h = Sel_floh(nyears);
		Sfutcru_m = Sel_crum(nyears);
		Sfutcru_h = Sel_cruh(nyears);
		BDfut = BD(nyears);
		qfut_flo = exp(log_q_cpue_fut);
		qfut_cru = exp(log_q_cru_fut);
		//cout << "qfut_cru" << endl; exit(1);
		for(i = nyears+1; i <= nyears + nyear_proy; i++){
			 
			rec_epsilon(i) = ran_rec(i)*cvar(1);
			cru_epsilon(i) = ran_cru(i)*cv_index(3,nyears);
			cpue_epsilon(i) = ran_cpue(i)*cv_index(2,nyears);
			
			//N poblacional futuro por edad
			Nfut_m(2,nedades) = ++elem_prod(Nfut_m(1,nedades-1),Sfut_m(1,nedades-1));
			//Rfut = (alfa*BDfut/(beta + BDfut))*exp(rec_epsilon(i) + 0.5*cvar(1));
			Rfut(l,i) = (BDfut/(alfa + beta*BDfut))*exp(rec_epsilon(i) + 0.5*cvar(1));
			Nfut_m(1) = Prm*Rfut(l,i);
			Nfut_m(nedades) = Nfut_m(nedades)+Nfut_m(nedades)*Sfut_m(nedades);// grupo plus
			Nfut_h(2,nedades) = ++elem_prod(Nfut_h(1,nedades-1),Sfut_h(1,nedades-1));
			Nfut_h(1) = (1 - Prm)*Rfut(l,i);
			Nfut_h(nedades) = Nfut_h(nedades)+Nfut_h(nedades)*Sfut_h(nedades);// grupo plus
			
			//Numero vulnerable por talla - flota
		    NVfutflo_h = elem_prod(Nfut_h,Sfutflo_h)*Prob_talla_h; //Abundancia vulnerable comienzos de año
		    NVfutflo_m = elem_prod(Nfut_m,Sfutflo_m)*Prob_talla_m; 
            //Numero vulnerable por talla - crucero
		    NVfutcru_h = elem_prod(Nfut_h,Sfutcru_h)*Prob_talla_h;
		    NVfutcru_m = elem_prod(Nfut_m,Sfutcru_m)*Prob_talla_m;
			
			//Biomasa media por talla por sexo
			BMfut_flo_m = NVfutflo_m*Wmed(1);
			BMfut_flo_h = NVfutflo_h*Wmed(2);
			BMfut_flo = BMfut_flo_m + BMfut_flo_h;
		    BMfut_cru_m = NVfutcru_m*Wmed(1);
		    BMfut_cru_h = NVfutcru_h*Wmed(2);
			BMfut_cru = BMfut_cru_m + BMfut_cru_h;
		    //biomasa total futuro
 			//cout << "BMfut_cru" << BMfut_cru << endl;exit(1);
			
			bcru_fut(i) = qfut_cru*BMfut_cru*exp(cru_epsilon(i));
			//cout << "bcru_fut: " << bcru_fut << endl;exit(1);
			//====+===+=== REGLAS EMPIRICAS ===+===+
			ytp=0;
			if(l==1){
				mu_ref = 0.3;
				ytp = mu_ref*bcru_fut(i);
			}
			if(l==2){
				mu_ref = 0.15;
				ytp = mu_ref*bcru_fut(i);
			}
			
			if(l==3){
				if(bcru_fut(i) < 14820){
					ytp=(0.12*bcru_fut(i))*((bcru_fut(i)/14820) - 0.25)/0.75;
					if(bcru_fut(i) < 3706){
						ytp=0;
					}
				}else{ytp = 0.15*bcru_fut(i);}
			}
			if(l==4){
				if(bcru_fut(i) < 14820){
					ytp = 0.12*bcru_fut(i);
				}else{ytp = 1776;}
			}
			//procedimiento de manejo
			if(hyper==1){
				if(i == nyears+1){
					if(ytp > 1.15*Desemb(nyears)){ytp = 1.15*Desemb(nyears);}
				}else{
					if(ytp > 1.15*C_fut(l,i-1)){ytp = 1.15*C_fut(l,i-1);}
				}
			}
			
			//cout << "BMfut_cru_m: " << BMfut_cru_m << endl;
			//cout << "BMfut_cru_h: " << BMfut_cru_h << endl;
			//cout << "bcru_fut: " << bcru_fut << endl;
			//cout << "BDfut :" << BDfut << endl; 
			//cout << "YTP: " << ytp << endl;exit(1);
			
			//Calcula F a partir de la captura y biomasa vulnerable por sexo
			C_fut(l,i)=ytp;
			//TODO: hacer una variable aleatoria de proporcion de hembras
			prop_h_fut(i) = 0.4; //proporcion en peso de hembras en el desembarque
			
			if(C_fut(l,i)!=0){
			//Estima la mortalidad asumiendo F por sexo desde captura total sobre biomasa vulnerable parcial por sexo:
			// TODO: verificar supuesto machos
				//MACHOS
				bvuln_fut(i) = BMfut_flo_m;
			    dvariable ffpen = 0.0;
			    dvariable SK = posfun((bvuln_fut(i) - (1-prop_h_fut(i))*C_fut(l,i))/bvuln_fut(i),0.05,ffpen);
			    Kobs_tot_catch = bvuln_fut(i) - SK*bvuln_fut(i);
				M_tmp = Mm;
				sel=Sfutflo_m; //selectividad a la edad
				do_Newton_Raphson_for_mortality(i);				
			    Fm_fut(i) = F_tmp(i);
				//HEMBRAS
				bvuln_fut(i) = BMfut_flo_h;
			    ffpen = 0.0;
			    SK = posfun((bvuln_fut(i) - prop_h_fut(i)*C_fut(l,i))/bvuln_fut(i),0.05,ffpen);
			    Kobs_tot_catch = bvuln_fut(i) - SK*bvuln_fut(i);
				M_tmp = Mh;
				sel=Sfutflo_h; //selectividad a la edad
				do_Newton_Raphson_for_mortality(i);				
			    Fh_fut(i) = F_tmp(i);
			}
			else{
				Fm_fut(i)=0;
				Fh_fut(i)=0;
			}
		    Zfut_m = Fm_fut(i)+Mm;
			Zfut_h = Fh_fut(i)+Mh;
			Sfut_m = exp(-1*Zfut_m);
			Sfut_h = exp(-1*Zfut_h);
			Fyr_fut(i) = max(Fh_fut(i));
			//Reclacula los indicadores después que la mortalidad total fue calculada
			//Biomasa vulnerable
			NVfutflo_m = elem_prod(elem_prod(Nfut_m,mfexp(-dt(2)*Zfut_m)),Sfutflo_m)*Prob_talla_m;
			NVfutflo_h = elem_prod(elem_prod(Nfut_h,mfexp(-dt(2)*Zfut_h)),Sfutflo_h)*Prob_talla_h;
			BMfut_flo_m = NVfutflo_m * Wmed(1); //Biomasa vulnerable machos
			BMfut_flo_h = NVfutflo_h * Wmed(2); //Biomasa vulnerable hembras
			BMfut_flo = BMfut_flo_m + BMfut_flo_h;
            //Numero vulnerable por talla - crucero
		    NVfutcru_h = elem_prod(elem_prod(Nfut_h,mfexp(-dt(3)*Zfut_m)),Sfutcru_h)*Prob_talla_h;
		    NVfutcru_m = elem_prod(elem_prod(Nfut_m,mfexp(-dt(3)*Zfut_m)),Sfutcru_m)*Prob_talla_m;
		    BMfut_cru_m = NVfutcru_m*Wmed(1);
		    BMfut_cru_h = NVfutcru_h*Wmed(2);
			BMfut_cru = BMfut_cru_m+BMfut_cru_h;
		    //biomasa total futuro
 			
			bcru_fut(i) = qfut_cru*BMfut_cru*exp(cru_epsilon(i));
			//CPUE
			cpue_fut(i) = qfut_flo*BMfut_flo*exp(cpue_epsilon(i));
			//Biomasa desovante
		    ssb_fut(i)=sum(elem_prod(elem_prod(Nfut_h,exp(-dt(1)*Zfut_h))*Prob_talla_h,elem_prod(msex,Wmed(2))));
			//Biomasa total futuro
			BTfut_m = (Nfut_m*Prob_talla_m)*Wmed(1);
			BTfut_h = (Nfut_h*Prob_talla_h)*Wmed(2);
		    BTfut(i)=BTfut_m+BTfut_h;
			BDfut = ssb_fut(i);
			RPRfut(l,i) = ssb_fut(i)/SSBo;
			
			//cout << "ssb_fut: " << ssb_fut << endl;

			//Estructura de tallas - pesqueria y cruceros
			//Ahora simula la composicion por edad y por talla						
			
			for(int j=1;j<=nedades;j++){ //captura por edad
				catage_m(i,j) = (Fm_fut(i,j)/Zfut_m(j))*Nfut_m(j)*(1.-Sfut_m(j)); //machos
				catage_h(i,j) = (Fh_fut(i,j)/Zfut_h(j))*Nfut_h(j)*(1.-Sfut_h(j)); //hembras
			}
			//cout << "catage_h: " << catage_h << endl;
			catlen_m(i) = catage_m(i)*Prob_talla_m;
			catlen_h(i) = catage_h(i)*Prob_talla_h;
			for(int j =1; j<=ntallas; j++){
				fut_pflo_m(i,j) = catlen_m(i,j)/sum(catlen_m(i) + 1e-10);
				fut_pflo_h(i,j) = catlen_h(i,j)/sum(catlen_h(i) + 1e-10);
				fut_pcru_m(i,j) = NVfutcru_m(j)/sum(NVfutcru_m + 1e-10);
				fut_pcru_h(i,j) = NVfutcru_h(j)/sum(NVfutcru_h + 1e-10);		
			}
			//cout << "catlen_h: " << catlen_h << endl;exit(1);
	      //=========== ESCRITURA DEL ARCHIVO *.dat ===============
			upk = i;
			yrs_fut(i) = numyear+i-1;
	        ofstream simdata(simname);
	        simdata << "# SIMULACION DE DATOS" << endl;
	        simdata << "# Numero de anos" << endl;
	        simdata << upk << endl;   
	        simdata << "# Numero de edades"<<endl;
	        simdata << nedades << endl;	
	        simdata << "# numero de intervalos de tallas " << endl;
	        simdata << ntallas << endl;
			simdata << data << endl;
	        simdata << "# MATRIZ DE DATOS SIMULADOS " << endl;
	        for(k = nyears + 1; k <= upk; k++){
				simdata << " " << yrs_fut(k) << "  " << C_fut(l,k) << "  " << cpue_fut(k) << "  " << bcru_fut(k) << "  " << prop_h_fut(k) << "  " << 0.1 << "  " << 0.15 << "  " << 0.3 << "  " << 0.05 << "  " << 72.19 << "  " << 65.03 << "  " << 72.63 << "  " << 50.66 << endl;
			}	
	        simdata << "#edades" << endl;
	        simdata << vec_ages << endl;
	        simdata << "#tallas" << endl;
	        simdata << vec_tallas << endl;
	        simdata << "#Estructura de tallas historica" << endl;
			simdata << "#prop talla machos" << endl;
			simdata << pobs_flom << endl;
	        simdata << "# flota simulados machos " << endl;
	        for(k = nyears + 1; k <= upk; k++){
				simdata << fut_pflo_m(k) << endl;
	      	}
			simdata << "#prop talla hembras" << endl;
			simdata << pobs_floh << endl;
	        simdata << "# flota simulados hembras " << endl;
	        for(k = nyears + 1; k <= upk; k++){
				simdata << fut_pflo_h(k) << endl;
	      	}
	        simdata << "#Estructura de tallas crucero historica" << endl;
	        simdata << "#machos " << endl;
			simdata << pobs_crum << endl;
			simdata << "#simulados machos " << endl;
	        for(k = nyears + 1; k <= upk; k++){
				simdata << fut_pcru_m(k) << endl;
			}
			simdata << "#hembras " << endl;
			simdata << pobs_cruh << endl;
	        simdata << "#simulados hembras " << endl;
	        for(k = nyears + 1; k <= upk; k++){
				simdata << fut_pcru_h(k) << endl;
			}	  
	      	simdata.close();
	        rv=system("./paso2.sh");
			//Lee los indicadores de estatus del estimador.  
			ifstream eval_estatus("estatus.dat");
			eval_estatus >> eval_now;
			eval_estatus.close();
			keep_Btot(l,i)=eval_now(1);//biomasa total 
			keep_SSBt(l,i)=eval_now(2);//biomasa desovante
			keep_Rt(l,i)=eval_now(3); //Reclutamiento
			keep_Ro(l,i)=eval_now(4); 
			keep_Ft(l,i)=eval_now(5);//mortalidad por pesca
			//Guarda las cantidades equivalentes del MOP
			des_Btot(l,i) =BTfut(i); 
			des_SSBt(l,i) = ssb_fut(i);
			des_Rt(l,i) = Rfut(l,i);
			des_Ro(l,i) = RPRfut(l,i);
			des_F(l,i) = Fyr_fut(i);
	        //======LEE GRADIENTE ===
	        ifstream lee_grad("grad_final.txt");
	        lee_grad >> grad_tmp;
	        lee_grad.close();
	        if(grad_tmp > 0.001){check_convergence=0;}else{check_convergence=1;}
		 }
	}

    //======== REPORTA SIMULACIONES Y ESTIMACIONES
    //Capturas efectivas		       
    rep1 << C_fut << endl;
    //Guarda variables de estado del simulador y estimador
    //Simulador
    rep2 << des_Btot << endl;
    rep3 << des_SSBt << endl;
    rep4 << des_Rt << endl;
    rep5 << des_F << endl;
    rep15 << des_Ro <<endl;
 
    //Estimador
    rep6 << keep_Btot << endl;
    rep7 << keep_SSBt << endl;
    rep8 << keep_Rt << endl;
    rep9 << keep_Ft << endl;
    //rep14 << keep_RBB <<endl; 
    //Variables en la fase histórica
    rep10 << Fyr << endl; //mortalidad pesca         
    rep11 << BD << endl; //desovante
    rep12 << BT << endl; //biomasa total
    rep13 << Rest << endl; //Reclutas       DUDA 
    rep16 << RPRlp <<endl;
	rep17 << bcru_fut <<endl;

    rep_grad << check_convergence << endl;


FUNCTION void do_Newton_Raphson_for_mortality(int i)
		  dvariable Fold = Kobs_tot_catch/bvuln_fut(i);
		  dvariable Fnew ;
		  for (int ii=1;ii<=5;ii++)
		  {
		      dvariable ZZ = Fold + M_tmp;
		      dvariable XX = exp(-1.*ZZ);
		      dvariable AA = Fold * (1. - XX);
		      dvariable BB = ZZ;
		      dvariable CC = 1. + (Fold - 1) * XX;
		      dvariable dd = 1.;
		      dvariable FX = AA / BB - Kobs_tot_catch/bvuln_fut(i);
		      dvariable FPX = (BB * CC - AA * dd) / (BB * BB);
		      Fnew = Fold - FX / FPX;
		      Fold = Fnew;
		  }
		  F_tmp(i)=Fnew*sel;



 /*	  
 FUNCTION Sim_data	  
	  
    //dvector epsilon_rec_fut(nanos+1,nanos+nanos_proy);
    dvector epsilon_CPUE_sim(1,nyears);
    dvector epsilon_Bcru_sim(1,nyears);
	dvector epsilon_prop_h_sim(1,nyears);
    dvector CPUE_epsilon_sim(1,nyears);
    dvector Bcru_epsilon_sim(1,nyears);
	dvector prop_h_epsilon_sim(1,nyears);
    int k;
    simname="Lam.dat"; //nombre de los datos simulados para el estimador
    dvariable grad_tmp;
    dvariable check_convergence;
	dvector p(1,ntallas);
    dvector freq(1,ntallas); //
    ivector bin(1,400);

    epsilon_CPUE_sim.fill_randn(rng);
    epsilon_Bcru_sim.fill_randn(rng);
	epsilon_prop_h_sim.fill_randn(rng);
    int rv;
  //===== SIMULA LOS INDICES DE ABUNDANCIA
    CPUE_epsilon_sim=exp(epsilon_CPUE_sim* 0.15);
    Bcru_epsilon_sim=exp(epsilon_Bcru_sim* 0.3);
	prop_h_epsilon_sim=exp(epsilon_prop_h_sim*0.05);
	  
    for(int i=1;i<=nyears;i++){
    if(Bcru(i)!=0){
    sim_Bcru(i)=pred_Bcru(i)*Bcru_epsilon_sim(i);}else{sim_Bcru(i)=0;
	}
    if(CPUE(i)!=0){
	sim_CPUE(i) = pred_CPUE(i)*CPUE_epsilon_sim(i);}else{sim_CPUE(i)=0;}
	
	if(prop_h(i)!=0){
	sim_prop_h(i)=prop_hpred(i)*prop_h_epsilon_sim(i);}else{sim_prop_h(i)=0;}	   
	} //Cierra ciclo indices
	//cout << "HASTA AQUI..." << endl;exit(1); 

    //==== SIMULA COMP x TALLA
    //=== pesqueria
	
	//hembras
    freq.initialize();
	for(int i=1;i<=nyears;i++){
    sim_p_len_f_h(i) = ppred_floh(i)/sum(ppred_floh(i));
    p = value(sim_p_len_f_h(i));
    p/=sum(p);
 	bin.fill_multinomial(rng,p);
    for(int j=1;j<=400;j++){freq(bin(j))++;}
 	p = freq/sum(freq);
	//agrega ceros
 	if(sum(Catsize(2)(i))!=0){sim_p_len_f_h(i)=p;}else{sim_p_len_f_h(i)=Catsize(2)(i);}}
   	
	//machos
    freq.initialize();
	for(int i=1;i<=nyears;i++){
    sim_p_len_f_m(i) = ppred_flom(i)/sum(ppred_flom(i));
    p = value(sim_p_len_f_m(i));
    p/=sum(p);
    bin.fill_multinomial(rng,p);
    for(int j=1;j<=400;j++){freq(bin(j))++;}
    p = freq/sum(freq);
    //agrega ceros
    if(sum(Catsize(1)(i))!=0){sim_p_len_f_m(i)=p;}else{sim_p_len_f_m(i)=Catsize(1)(i);}}

 	//== Crucero==
    freq.initialize();
	for(int i=1;i<=nyears;i++){
    sim_p_len_cru_h(i) = ppred_cruh(i)/sum(ppred_cruh(i));
    p = value(sim_p_len_cru_h(i));
    p/=sum(p);
 	   bin.fill_multinomial(rng,p);
        for(int j=1;j<=400;j++){freq(bin(j))++;}
 	   p = freq/sum(freq);
 	   //agrega ceros
 	if(sum(Catsize(4)(i))!=0){sim_p_len_cru_h(i)=p;}else{sim_p_len_cru_h(i)=Catsize(4)(i);}}
	
    freq.initialize();
	for(int i=1;i<=nyears;i++){
    sim_p_len_cru_m(i) = ppred_crum(i)/sum(ppred_crum(i));
    p = value(sim_p_len_cru_m(i));
    p/=sum(p);
 	   bin.fill_multinomial(rng,p);
        for(int j=1;j<=400;j++){freq(bin(j))++;}
 	   p = freq/sum(freq);
 	   //agrega ceros
	if(sum(Catsize(3)(i))!=0){sim_p_len_cru_m(i)=p;}else{sim_p_len_cru_m(i)=Catsize(3)(i);}}
 	//cout << "HASTA AQUI..." << endl;exit(1);  
   //=========== ESCRITURA DEL ARCHIVO *.dat ===============
     ofstream simdata(simname);
     simdata << "# SIMULACION DE DATOS" << endl;
     simdata << "# Numero de anos" << endl;
     simdata << nyears << endl;   
     simdata << "# Numero de edades"<<endl;
     simdata << nedades << endl;	
     simdata << "# numero de intervalos de tallas " << endl;
     simdata << ntallas << endl;		
     simdata << "# MATRIZ DE DATOS SIMULADOS " << endl;
     for(k=1;k<=nyears;k++){
	 simdata << " "<< yrs(k) << "  " << Desemb(k) << "  " << sim_CPUE(k) << "  " << sim_Bcru(k) << "  " << prop_hpred(k) << "  " << 0.1 << "  " << 0.15 << "  " << 0.3 << "  " << 0.05 << "  " << 72.19 << "  " << 65.03 << "  " << 72.63 << "  " <<         50.66 << "  " << endl;}
     simdata << "#vector de edades" << endl;
     simdata << vec_ages << endl;
     simdata << "#vector de tallas" << endl;
     simdata << vec_tallas << endl;
     simdata << "#Estructura de tallas historica simulada" << endl;
     simdata << "# flota simulados machos " << endl;
     if(simcomptalla==1){
   	 for(k=1;k<=nyears;k++){
   	 simdata << sim_p_len_f_m(k) << endl;
   	 }}
   	 if(simcomptalla!=1){
     for(k=1;k<=nyears;k++){
   	 simdata << Catsize(1)(k) << endl;
   	 }}	
     simdata << "# flota simulados hembras " << endl;
     if(simcomptalla==1){
   	 for(k=1;k<=nyears;k++){
   	 simdata << sim_p_len_f_h(k) << endl;
   	 }}
   	 if(simcomptalla!=1){
     for(k=1;k<=nyears;k++){
   	 simdata << Catsize(2)(k) << endl;
   	 }}
     simdata << "#Estructura de tallas historica simulada" << endl;
     simdata << "# flota simulados machos " << endl;
     if(simcomptalla==1){
   	 for(k=1;k<=nyears;k++){
   	 simdata << sim_p_len_cru_m(k) << endl;
   	 }}
   	  if(simcomptalla!=1){
      for(k=1;k<=nyears;k++){
   	  simdata << Catsize(3)(k) << endl;
   	  }}	
      simdata << "# flota simulados hembras " << endl;
      if(simcomptalla==1){
   	  for(k=1;k<=nyears;k++){
   	  simdata << sim_p_len_cru_h(k) << endl;
   	  }}
   	  if(simcomptalla!=1){
      for(k=1;k<=nyears;k++){
   	  simdata << Catsize(4)(k) << endl;
   	  }}	  
   	  simdata.close();
      rv=system("./run_est.sh");
      // === LEE SSB estimada
      ifstream eval_ssb("ssb_estimador.txt");
      eval_ssb >> keep_SSBt;
      eval_ssb.close();
      // === LEE Reclutamiento estimado
      ifstream eval_rt("rt_estimador.txt");
      eval_rt >> keep_Rt;
      eval_rt.close();
      //=== LEE Fmort estimado
      ifstream eval_ft("fmort_estimador.txt");
      eval_ft >> keep_Ft;
      eval_ft.close();
      //=== LEE So estimado
      ifstream eval_so("so_estimador.txt");
      eval_so >> keep_so;
      eval_so.close();
      //=== LEE RPR
      ifstream eval_rpr("rpr_estimador.txt");
      eval_rpr >> keep_rpr;
      eval_rpr.close();  

      //======LEE GRADIENTE ===
      ifstream lee_grad("grad_final.txt");
      lee_grad >> grad_tmp;
      lee_grad.close();
      if(grad_tmp>0.001){check_convergence=0;}else{check_convergence=1;}
      //======== REPORTA SIMLACIONES Y ESTIMACIONES
      //Simulador
      rep1 << BD << endl;
      rep2 << Rest << endl;
      rep3 << mfexp(log_Fh) << endl;
      rep7 << SSBo << endl;
      rep8 << RPRlp << endl;
      //Estimador
      rep4 << keep_SSBt << endl;
      rep5 << keep_Rt << endl;
      rep6 << keep_Ft << endl;
      rep9 << keep_so << endl;
      rep10 << keep_rpr << endl;
  
      //reporta el gradiente
      rep_grad << check_convergence << endl;
	*/ 

FUNCTION Eval_prob_talla_edad


 int i, j;

// genero una clave edad-talla para otros calculos. Se modela desde L(1)
 mu_edadm(1)=exp(log_Lom);
 
 for (i=2;i<=nedades;i++)
  {
  mu_edadm(i)=Linfm*(1-exp(-K_m))+exp(-K_m)*mu_edadm(i-1);
  }

 sigma_edadm=exp(log_cv_edadm)*mu_edadm;

 mu_edadh(1)=exp(log_Loh);
 for (i=2;i<=nedades;i++)
  {
  mu_edadh(i)=Linfh*(1-exp(-K_h))+exp(-K_h)*mu_edadh(i-1);
  }
 sigma_edadh=exp(log_cv_edadh)*mu_edadh;

  Prob_talla_m = ALK( mu_edadm, sigma_edadm, vec_tallas);
  Prob_talla_h = ALK( mu_edadh, sigma_edadh, vec_tallas);

 // Función extraida desde ADMB Documentation (Steve Martell)
FUNCTION dvar_matrix ALK(dvar_vector& mu, dvar_vector& sig, dvector& x)
	//RETURN_ARRAYS_INCREMENT();
	int i, j;
	dvariable z1;
	dvariable z2;
	int si,ni; si=mu.indexmin(); ni=mu.indexmax();
	int sj,nj; sj=x.indexmin(); nj=x.indexmax();
	dvar_matrix pdf(si,ni,sj,nj);
	pdf.initialize();
	double xs=0.5*(x[sj+1]-x[sj]);
	for(i=si;i<=ni;i++) //loop over ages
	{
		 for(j=sj;j<=nj;j++) //loop over length bins
		{
			z1=((x(j)-xs)-mu(i))/sig(i);
			z2=((x(j)+xs)-mu(i))/sig(i);
			pdf(i,j)=cumd_norm(z2)-cumd_norm(z1);
		}//end nbins
		pdf(i)/=sum(pdf(i));
	}//end nage
	//RETURN_ARRAYS_DECREMENT();
	return(pdf);


FUNCTION Eval_selectividad
 int i,j; 


// FLOTA

 for (j=1;j<=nbloq_selflo;j++){

 S_flom(j)=1/(1+exp(-log(19)*(vec_ages-exp(log_L50flom(j)))/exp(log_sdL50flomL(j))));//machos // Porque no esta dividido en la diferencia entre A95-A50?
 S_floh(j)=1/(1+exp(-log(19)*(vec_ages-exp(log_L50floh(j)))/exp(log_sdL50flohL(j))));//hembras

 }

   for (i=1;i<=nyears;i++){
      for (j=1;j<=nbloq_selflo;j++){
              if (yrs(i)>=ybloq_selflo(j)){
                Sel_flom(i)=S_flom(j);//machos
                Sel_floh(i)=S_floh(j);} //hembras
       }
   }




 // CRUCEROS

 // por defecto los mismos que la flota
 //    Sel_crum=Sel_flom;
 //   Sel_cruh=Sel_floh;
    //Sel_crum=1.0;
    //Sel_cruh=1.0;


 if(active(log_L50crum)){

 for (j=1;j<=nbloq_selcru;j++){

 S_crum(j)=1/(1+exp(-log(19)*(vec_ages-exp(log_L50crum(j)))/exp(log_sdL50crumL(j))));
 S_cruh(j)=1/(1+exp(-log(19)*(vec_ages-exp(log_L50cruh(j)))/exp(log_sdL50cruhL(j))));

 }

   for (i=1;i<=nyears;i++){
      for (j=1;j<=nbloq_selcru;j++){
              if (yrs(i)>=ybloq_selcru(j)){
                Sel_crum(i)=S_crum(j);
                Sel_cruh(i)=S_cruh(j);}
       }
   }

 }



FUNCTION Eval_mortalidades

 Mm=exp(log_Mm);
 Mh=exp(log_Mh);
 
 Fm=elem_prod(Sel_flom,outer_prod(mfexp(log_Fm),Unos_edad));
 Fh=elem_prod(Sel_floh,outer_prod(mfexp(log_Fh),Unos_edad));

 Zm=Fm+Mm;
 Zh=Fh+Mh;

 Sm=mfexp(-1.0*Zm);
 Sh=mfexp(-1.0*Zh);
 //Cubillos para mop
 Fyr = mfexp(log_Fh);

FUNCTION Eval_abundancia
 int i, j;
 Prm = exp(log_propmR)/(1 + exp(log_propmR));
 // Biomasa desovante virgen de largo plazo
 No(1)=exp(log_Ro)*(1-Prm); // hembras
 
 for (int j=2;j<=nedades;j++)
 {
   No(j)=No(j-1)*exp(-1.*Mh);
 }
 
 //   No(nedades)+=No(nedades)*exp(-1.*Mh);
 No(nedades)=No(nedades)*exp(-1.*Mh)/(1-exp(-1.*Mh)); // Grupo Plus
 SSBo=sum(elem_prod(No*exp(-dt(1)*Mh)*Prob_talla_h,elem_prod(msex,Wmed(2))));

 // Stock-recluta
 //alfa=4*h*exp(log_Ro)/(5*h-1);//
 //beta=(1-h)*SSBo/(5*h-1);//  
 alfa = (SSBo*(1-h))/(4*h*mfexp(log_Ro));
 beta = (5*h-1)/(4*h*mfexp(log_Ro));
 //Prm = exp(log_propmR)/(1 + exp(log_propmR));
// genero una estructura inicial en equilibrio para el primer a�o
 Neqh(1)=mfexp(log_Ro)*(1 - Prm);//hembras

 for (j=2;j<=nedades;j++)
 {
   Neqh(j)=Neqh(j-1)*exp(-Zh(1,j-1));
 }
//   Neqh(nedades)+=Neqh(nedades)*exp(-1.*Zh(1,nedades)); // MODIFICAR POR LA OTRA FORMA
 Neqh(nedades)=Neqh(nedades)*exp(-1.*Zh(1,nedades))/(1-exp(-1.*Zh(1,nedades)));
 Neqm(1)=mfexp(log_Ro) * Prm;//(exp(log_propmR)/(1-exp(log_propmR)));//machos
 for (j=2;j<=nedades;j++)
 {
   Neqm(j)=Neqm(j-1)*exp(-Zm(1,j-1));
 }
   //Neqm(nedades)+=Neqm(nedades)*exp(-1.*Zm(1,nedades));//
 Neqm(nedades)=Neqm(nedades)*exp(-1.*Zm(1,nedades))/(1-exp(-1.*Zm(1,nedades)));
// Abundancia inicial
 Nm(1)=elem_prod(Neqm,exp(log_dev_Nom));
 Nh(1)=elem_prod(Neqh,exp(log_dev_Noh));
 BD(1)=sum(elem_prod(elem_prod(Nh(1),exp(-dt(1)*Zh(1)))*Prob_talla_h,elem_prod(msex,Wmed(2))));
 Rpred(1)=mfexp(log_Ro);//
 Rest(1)=Nh(1,1)+Nm(1,1); //agregado cote

// se estima la sobrevivencia por edad(a+1) y año(t+1)
 for (i=1;i<nyears;i++)
 {
     Rpred(i+1)=mfexp(log_Ro);

// Reclutamiento estimado por un modelo B&H hembras
     if(i>=vec_ages(1)){
     //Rpred(i+1)=alfa*BD(i - vec_ages(1) + 1)/(beta + BD(i-vec_ages(1)+1));
	 Rpred(i+1)=(BD(i - vec_ages(1) + 1)/(alfa+beta*BD(i-vec_ages(1)+1)));
 	}

     Nm(i+1,1)=Rpred(i+1)*mfexp(log_dev_Ro(i))*Prm; //(1 - exp(log_propmR));  // Reclutas machos   
     Nh(i+1,1)=Rpred(i+1)*mfexp(log_dev_Ro(i))*(1 - Prm);// Reclutas hembras
     //Restim=column(Nh,1)+column(Nm,1);

// Abundancia edad 2 en adelante
     Nm(i+1)(2,nedades)=++elem_prod(Nm(i)(1,nedades-1),Sm(i)(1,nedades-1));
     Nm(i+1,nedades)=Nm(i+1,nedades)+Nm(i,nedades)*Sm(i,nedades);// grupo plus

     Nh(i+1)(2,nedades)=++elem_prod(Nh(i)(1,nedades-1),Sh(i)(1,nedades-1));
     Nh(i+1,nedades)=Nh(i+1,nedades)+Nh(i,nedades)*Sh(i,nedades);// grupo plus
     Rest(i+1)=Nh(i+1,1)+Nm(i+1,1); //agregado cote
     BD(i+1)=sum(elem_prod(elem_prod(Nh(i+1),exp(-dt(1)*Zh(i+1)))*Prob_talla_h,elem_prod(msex,Wmed(2))));
 }


FUNCTION Eval_deinteres

// Rutina para calcular RPR
 Nv=Nh;// solo para empezar los calculos

// se estima la sobrevivencia por edad(a+1) y año(t+1)
 for (int i=1;i<nyears;i++)
 {
     Nv(i+1)(2,nedades)=++Nv(i)(1,nedades-1)*exp(-1.0*Mh);
     Nv(i+1,nedades)=Nv(i+1,nedades)+Nv(i,nedades)*exp(-1.0*Mh);// grupo plus
 }

 NDv=elem_prod((Nv*exp(-dt(1)*Mh))*Prob_talla_h,outer_prod(Unos_yrs,msex));
 BDo=NDv*Wmed(2);
 RPR=elem_div(BD,BDo);

 RPRlp=BD/SSBo;



FUNCTION Eval_biomasas
 
 NMD=elem_prod(Nh,mfexp(-dt(1)*Zh))*Prob_talla_h;
 NMD=elem_prod(NMD,outer_prod(Unos_yrs,msex));
 
 NVflo_h=elem_prod(elem_prod(Nh,mfexp(-dt(2)*(Zh))),Sel_floh)*Prob_talla_h;
 NVflo_m=elem_prod(elem_prod(Nm,mfexp(-dt(2)*(Zm))),Sel_flom)*Prob_talla_m;
 
 NVcru_h=elem_prod(elem_prod(Nh,mfexp(-dt(3)*(Zh))),Sel_cruh)*Prob_talla_h;
 NVcru_m=elem_prod(elem_prod(Nm,mfexp(-dt(3)*(Zm))),Sel_crum)*Prob_talla_m;


// vectores de biomasas derivadas
 BD=NMD*Wmed(2);
 BMflo=NVflo_m*Wmed(1)+NVflo_h*Wmed(2);
 BMcru=NVcru_m*Wmed(1)+NVcru_h*Wmed(2);
 BV=BMflo;

 BT=(Nm*Prob_talla_m)*Wmed(1)+(Nh*Prob_talla_h)*Wmed(2);  
 


FUNCTION Eval_capturas_predichas

// matrices de capturas predichas por edad y año
 pred_Ctot_am=elem_prod(elem_div(Fm,Zm),elem_prod(1.-Sm,Nm));
 pred_Ctotm=pred_Ctot_am*Prob_talla_m;


 pred_Ctot_ah=elem_prod(elem_div(Fh,Zh),elem_prod(1.-Sh,Nh));
 pred_Ctoth=pred_Ctot_ah*Prob_talla_h;

// Proporción total anual de hembras en las capturas
 prop_hpred = elem_div(rowsum(pred_Ctoth),rowsum(pred_Ctoth+pred_Ctotm+1e-10));

// vectores de desembarques predichos por a�o
 pred_Desemb=pred_Ctotm*Wmed(1)+pred_Ctoth*Wmed(2);


// PROPORCIONES  matrices de proporcion de capturas por talla y año
 pobs_flom=elem_div(Catsize(1),outer_prod(rowsum(Catsize(1)+1e-10),Unos_tallas));
 ppred_flom=elem_div(pred_Ctotm,outer_prod(rowsum(pred_Ctotm+1e-10),Unos_tallas));

 pobs_floh=elem_div(Catsize(2),outer_prod(rowsum(Catsize(2)+1e-10),Unos_tallas));
 ppred_floh=elem_div(pred_Ctoth,outer_prod(rowsum(pred_Ctoth+1e-10),Unos_tallas));

 pobs_crum=elem_div(Catsize(3),outer_prod(rowsum(Catsize(3)+1e-10),Unos_tallas));
 ppred_crum=elem_div(NVcru_m,outer_prod(rowsum(NVcru_m+1e-10),Unos_tallas));

 pobs_cruh=elem_div(Catsize(4),outer_prod(rowsum(Catsize(4)+1e-10),Unos_tallas));
 ppred_cruh=elem_div(NVcru_h,outer_prod(rowsum(NVcru_h+1e-10),Unos_tallas));


 Lmf_obs  = vec_tallas*trans(pobs_flom);
 Lmf_pred = vec_tallas*trans(ppred_flom);
 Lhf_obs  = vec_tallas*trans(pobs_floh);
 Lhf_pred = vec_tallas*trans(ppred_floh);
 Lmc_obs  = vec_tallas*trans(pobs_crum);
 Lmc_pred = vec_tallas*trans(ppred_crum);
 Lhc_obs  = vec_tallas*trans(pobs_cruh);
 Lhc_pred = vec_tallas*trans(ppred_cruh);



FUNCTION Eval_indices

   for (int i=1;i<=nyears;i++){
      for (int j=1;j<=nbloq_qflo;j++){
              if (yrs(i)>=ybloq_qflo(j)){
                 pred_CPUE(i)=exp(log_qflo(j))*BMflo(i);}
       }
   }


   for (int i=1;i<=nyears;i++){
      for (int j=1;j<=nbloq_qcru;j++){
              if (yrs(i)>=ybloq_qcru(j)){
                 pred_Bcru(i)=exp(log_qcru(j))*BMcru(i);}
       }
   }



FUNCTION Eval_PBR

 for (int i=1;i<=npbr;i++)
 {
 Fpbrh=Sel_floh(nyears)*exp(log_Fref(i));
 Zpbrh=Fpbrh+Mh;

 Neqh(1)=mfexp(log_Ro);//hembras
 
 	for (int j=2;j<=nedades;j++)
	{
		Neqh(j)=Neqh(j-1)*exp(-Zpbrh(j-1));
	}
//   Neqh(nedades)+=Neqh(nedades)*exp(-1.*Zpbr(nedades)); // MODIFICAR POR LA OTRA FORMA
   Neqh(nedades)=Neqh(nedades)*exp(-1.*Zpbrh(nedades))/(1-exp(-1.*Zpbrh(nedades))); // MODIFICAR POR LA OTRA FORMA

 BD_lp=sum(elem_prod(elem_prod(Neqh,exp(-dt(1)*Zpbrh))*Prob_talla_h,elem_prod(msex,Wmed(2))));
 
 ratio_pbr(i)=BD_lp/SSBo;
 }

 Frpr=mfexp(log_Fh)/mfexp(log_Fref(3));
 
 
 
FUNCTION Eval_logverosim
// esta funcion evalua el nucleo de las -log-verosimilitudes marginales para series con datos 0

 int i;

 suma1=0; suma2=0; suma3=0; penalty=0;

 for (i=1;i<=nyears;i++)
 {
  if (CPUE(i)>0){
    suma1+=square(log(CPUE(i)/pred_CPUE(i))*1/cv_index(2,i));}
  if (Bcru(i)>0){
    suma2+=square(log(Bcru(i)/pred_Bcru(i))*1/cv_index(3,i));}
  if (prop_h(i)>0){
    suma3+=square(log(prop_h(i)/prop_hpred(i))*1/cv_index(4,i));}
 }



FUNCTION Eval_funcion_objetivo

 suma4=0; suma5=0; suma6=0; suma7=0; penalty=0;

 likeval(1)=0.5*suma1;//CPUE
 likeval(2)=0.5*suma2;//Crucero
 likeval(3)=0.5*norm2(elem_div(log(elem_div(Desemb,pred_Desemb)),cv_index(1)));// desemb

 likeval(4)=0.5*suma3;// prop p_hembras
 likeval(5)=-1.*sum(nm_flocru(1)*elem_prod(pobs_flom,log(ppred_flom)));
 likeval(6)=-1.*sum(nm_flocru(2)*elem_prod(pobs_floh,log(ppred_floh)));
 likeval(7)=-1.*sum(nm_flocru(3)*elem_prod(pobs_crum,log(ppred_crum)));
 likeval(8)=-1.*sum(nm_flocru(4)*elem_prod(pobs_cruh,log(ppred_cruh)));

// lognormal Ninicial y Reclutas
 if(active(log_dev_Ro)){
 likeval(9)=1./(2*square(cvar(1)))*norm2(log_dev_Ro);}
 
 if(active(log_dev_Nom)){
 likeval(10)=1./(2*square(cvar(2)))*norm2(log_dev_Nom);
 likeval(11)=1./(2*square(cvar(2)))*norm2(log_dev_Noh);}
 
 /*if(active(log_sdL50flomR)){
 likeval(12)=lambda*norm2(log_sdL50flomR-log_s2priorm);}
 
 if(active(log_sdL50flohR)){
 likeval(13)=lambda*norm2(log_sdL50flohR-log_s2priorh);}

 if(active(log_sdL50crumR)){
 likeval(14)=lambda*norm2(log_sdL50crumR-log_s2priorcm);}
 
 if(active(log_sdL50cruhR)){
 likeval(15)=lambda*norm2(log_sdL50cruhR-log_s2priorch);}
 */

 if (active(log_propmR)){
 likeval(16)=0.5/square(cvar(3))*square(log_propmR + 0.69315);}

 if (active(log_Lom)){
 likeval(17)=0.5*square((log_Lopriorm-log_Lom)/cv_priors(3));
 likeval(18)=0.5*square((log_Lopriorh-log_Loh)/cv_priors(3));}

 if (active(log_cv_edadm)){
 likeval(19)=0.5*square((log_cv_edadm-log_cva_priorm)/cv_priors(4));
 likeval(20)=0.5*square((log_cv_edadh-log_cva_priorh)/cv_priors(4));}

 if(active(log_Mh)){
 penalty+=100*(square(log_M_priorh-log_Mh)+square(log_M_priorm-log_Mm));}

 if(active(log_qcru)){
 penalty+=0.5*norm2((log_qcru-log_qcru_prior)/cv_qcru);}

 if(active(log_Fref)){
 penalty+=1000*norm2(ratio_pbr-tasa_bdpr);}

   
 if (active(log_Fh)){
 //penalty+=100*(square(log_Fh(1)-mean(log_Fh))+square(log_Fh(4)-mean(log_Fh))+square(log_Fh(5)-mean(log_Fh))+square(log_Fh(6)-mean(log_Fh))); } //+square(log_Fh(6)-mean(log_Fh))); }
 penalty+=10*(square(log_Fh(1)-mean(log_Fh))+square(log_Fh(2)-mean(log_Fh))+square(log_Fh(4)-mean(log_Fh))+square(log_Fh(5)-mean(log_Fh))); }

 if (active(log_Fm)){
 penalty+=10*(square(log_Fm(1)-mean(log_Fm))+square(log_Fm(2)-mean(log_Fm))+square(log_Fm(4)-mean(log_Fm))+square(log_Fm(5)-mean(log_Fm))); } //+square(log_Fm(6)-mean(log_Fm))); }
 //penalty+=1000*(square(log_Fm(1)-mean(log_Fm))+square(log_Fm(3)-mean(log_Fm))+square(log_Fm(4)-mean(log_Fm))+square(log_Fm(5)-mean(log_Fm))+square(log_Fm(6)-mean(log_Fm))); }
 

 f=opt_sim*sum(likeval)+penalty;
 
 
 /* 
 FUNCTION Eval_CTP
// se considera el Fpbr de hembras como el representativo factor limitante

 for (int j=1;j<=npbr;j++)
 { // son # PBR only!
	Nph=Nh(nyears);
	Npm=Nm(nyears);
	
	Sph=Sh(nyears);
	Spm=Sm(nyears);
	
	BDp=BD(nyears);
	
	Fpbrh=Fh(nyears);
	Fpbrm=Fm(nyears);
	
	Zpbrh=Zh(nyears);
	Zpbrm=Zm(nyears);
	
	for (int i=1;i<=nyear_proy;i++)
	{
		Bph=sum(elem_prod(Nph*Prob_talla_h,Wmed(2)));
		Bpm=sum(elem_prod(Npm*Prob_talla_m,Wmed(1)));
		NMDp=elem_prod(Nph,mfexp(-dt(1)*Zpbrh))*Prob_talla_h;
		BDp=sum(elem_prod(elem_prod(NMDp,msex),Wmed(2)));
		CTP=elem_prod(elem_prod(elem_div(Fpbrh,Zpbrh),elem_prod(Nph,(1-Sph)))*Prob_talla_h,Wmed(2));
		CTP+=elem_prod(elem_prod(elem_div(Fpbrm,Zpbrm),elem_prod(Npm,(1-Spm)))*Prob_talla_m,Wmed(1));
		YTP(i,j)=sum(CTP);
		SSBp(i,j)=BDp;
		BTp(i,j)=Bph+Bpm;
		// año siguiente
		Npplus=Nph(nedades)*Sph(nedades);
		Nph(2,nedades)=++elem_prod(Nph(1,nedades-1),Sph(1,nedades-1));
		Nph(nedades)+=Npplus;
		Nph(1)=pRec*exp(log_Ro);
		Npplus=Npm(nedades)*Spm(nedades);
		Npm(2,nedades)=++elem_prod(Npm(1,nedades-1),Spm(1,nedades-1));
		Npm(nedades)+=Npplus;
		Npm(1)=exp(log_Ro)*exp(log_propmR)/(1-exp(log_propmR));
		
		// Se considera el mismo F de hembras en los machos
		Fpbrh=Sel_floh(nyears)*exp(log_Fref(j));
		Fpbrm=Sel_flom(nyears)*exp(log_Fref(j));
		Zpbrh=Fpbrh+Mh;
		Zpbrm=Fpbrm+Mm;
		Sph=exp(-1.*Zpbrh);
		Spm=exp(-1.*Zpbrm);
	}
  //Ctp(i)=YTP(i,1);//agregado por cote
 }
 
 
 CBA=YTP(2);// es para el año proyectado
 
 
 // Rutina para la estimacion de RPR

 Nvp=Nv(nyears);// toma la ultima estimación
 
 for (int i=1;i<=nyear_proy;i++)
 {
	 Nvplus=Nvp(nedades)*exp(-1.0*Mh);
	 Nvp(2,nedades)=++Nvp(1,nedades-1)*exp(-1.0*Mh);
	 Nvp(nedades)+=Nvplus;
	 Nvp(1)=exp(log_Ro);
	 SDvp(i)=sum(elem_prod(Nvp*Prob_talla_h,elem_prod(Wmed(2),msex)));
 }

 for (int i=1;i<=npbr;i++)
 {
	 RPRp(i)=SSBp(nyear_proy,i)/SDvp(nyear_proy);
 }
 */
 
 
REPORT_SECTION

 report << "YRS" << endl;
 report << yrs << endl;
 report << "CPUE" << endl;
 report << CPUE << endl;
 report << "CPUE_pred" << endl;
 report << pred_CPUE << endl;
 report << "BCRU" << endl;
 report << Bcru << endl;
 report << "Bcru_pred" << endl;
 report << pred_Bcru << endl;
 report << "Desemb" << endl;
 report << Desemb << endl;
 report << "Desemb_pred" << endl;
 report << pred_Desemb << endl;
 report << "BD" << endl;
 report << BD << endl;
 report << "BT" << endl;
 report << BT << endl;
 report << "BV" << endl;
 report << BMflo << endl;
 report << "Rech_pre_est" << endl;
 report << Rpred<< endl;
 report << "N_1" << endl;
 report << column(Nh,1)<< endl;
 report << "Fm" << endl;
 report << rowsum(Fm)/nedades<< endl;
 report << "Fh" << endl;
 report << rowsum(Fh)/nedades<< endl;
 report << "PP_h_obs" << endl;
 report << prop_h << endl;
 report << "PP_h_pred" << endl;
 report << prop_hpred << endl;
 report << "Lm_obs" << endl;
 report << vec_tallas*trans(pobs_flom)<< endl;
 report << "Lm_pred" << endl;
 report << vec_tallas*trans(ppred_flom)<< endl;
 report << "Lh_obs" << endl;
 report << vec_tallas*trans(pobs_floh)<< endl;
 report << "Lh_pred" << endl;
 report << vec_tallas*trans(ppred_floh)<< endl;
 report << "Lmc_obs" << endl;
 report << vec_tallas*trans(pobs_crum)<< endl;
 report << "Lmc_est" << endl;
 report << vec_tallas*trans(ppred_crum)<< endl;
 report << "Lhc_obs" << endl;
 report << vec_tallas*trans(pobs_cruh)<< endl;
 report << "Lhc_est" << endl;
 report << vec_tallas*trans(ppred_cruh)<< endl;
 report << "Sflom_age" << endl;
 report << Sel_flom << endl;
 report << "Sfloh_age" <<endl;
 report << Sel_floh << endl;
 report << "Scrum_age" << endl;
 report << Sel_crum << endl;
 report << "Scruh_age" << endl;
 report << Sel_cruh << endl;
 report << "CAPTURAS" << endl;
 report << "pobs_mflo" << endl;
 report << (pobs_flom)<< endl;
 report << "ppred_mflo" << endl;
 report << (ppred_flom)<< endl;
 report << "pobs_hflo" << endl;
 report << (pobs_floh)<< endl;
 report << "Ppred_hflo" << endl;
 report << (ppred_floh)<< endl;
 report << "CRUCERO" << endl;
 report << "pobs_mcru" << endl;
 report << (pobs_crum)<< endl;
 report << "ppred_mcru" << endl;
 report << (ppred_crum)<< endl;
 report << "pobs_hcru" << endl;
 report << (pobs_cruh)<< endl;
 report << "ppred_hcru" << endl;
 report << (ppred_cruh)<< endl;
 report << "Abundancia a la edad"<< endl;
 report << "Nm"<< endl;
 report << Nm << endl;
 report << "Nh" << endl;
 report << Nh << endl;
 report << "Captura a la edad" <<endl;
 report << "Capt_mage" <<endl;
 report << pred_Ctot_am <<endl;
 report << "Capt_hage" <<endl;
 report << pred_Ctot_ah <<endl;
 report << "F_age" <<endl;
 report << "Fm_age" <<endl;
 report << Fm << endl;
 report << "Fh_age" << endl;
 report << Fh << endl;
 report << "BDo" << endl;
 report << BDo << endl;
 report << "BDoLP" << endl;
 report << SSBo << endl;
 report << "RPR" << endl;
 report << RPR << endl;
 report << "BD/BDo" << endl;
 report << RPRlp << endl;
 report << "Lo_h"  << endl;
 report << exp(log_Loh) << endl;
 report << "cv_h" << endl;
 report << exp(log_cv_edadh) << endl;
 report << "Lo_m" << endl;
 report << exp(log_Lom) << endl;
 report << "cv_m" << endl;
 report << exp(log_cv_edadm) << endl;
 report << "Mm" << endl;
 report << Mm << endl;
 report << "Mh" << endl;
 report << Mh <<endl;
 report << "mu_edadm" << endl;
 report << mu_edadm << endl;
 report << "mu_edadh" << endl;
 report << mu_edadh << endl;
 report << "Prob_talla_m" << endl;
 report << Prob_talla_m << endl;
 report << "Prob_talla_h" << endl;
 report << Prob_talla_h << endl;
 report << "LIKE" <<endl; //CPUE, Crucero,Desemb, prop,prop_mflo, prop_hflo,pobs_crum, pobs_cruh, Ro,No_m,     No_h,Lo_m,Lo_h,cvage_m, cvage_h
 report << likeval << endl;
 report << "q_cru" <<endl;
 report << exp(log_qcru) << endl;
 report << "q_flo" <<endl;
 report << exp(log_qflo) << endl;
 report << "alfa" << endl;
 report << alfa << endl;
 report << "beta" <<endl;
 report << beta << endl;
 report << "ratio_obj" <<endl;
 report << ratio_pbr << endl;
 report << " Fpbr" << endl;
 report << exp(log_Fref) << endl;
 //report << " RPR_lp" << endl;
 //report << RPRlp << endl;
 //report << "BT_proy" << endl;
 //report << BTp << endl;
 //report << "BD_proy" << endl;
 //report << SSBp << endl;
 //report << "C_proy" << endl;
 //report << YTP << endl;


// ESTIMA nm y CV

 suma1=0; suma2=0;nm1=1;cuenta1=0;

  for (int i=1;i<=nyears;i++)
  {
	  if (sum(pobs_flom(i))>0){
		  suma1=sum(elem_prod(ppred_flom(i),1-ppred_flom(i)));
		  suma2=norm2(pobs_flom(i)-ppred_flom(i));
		  nm1=nm1*suma1/suma2;
		  cuenta1+=1;
		  }
	}

 suma1=0;suma2=0;nm2=1;cuenta2=0;
  for (int i=1;i<=nyears;i++)
  {
	  if (sum(pobs_floh(i))>0)
	  {
		  suma1=sum(elem_prod(ppred_floh(i),1-ppred_floh(i)));
		  suma2=norm2(pobs_floh(i)-ppred_floh(i));
		  nm2=nm2*suma1/suma2;
		  cuenta2+=1;
		  }
	  }

 suma1=0;suma2=0;nm3=1;cuenta3=0;
  for (int i=1;i<=nyears;i++)
  {
	  if (sum(pobs_crum(i))>0)
	  {
		  suma1=sum(elem_prod(ppred_crum(i),1-ppred_crum(i)));
		  suma2=norm2(pobs_crum(i)-ppred_crum(i));
		  nm3=nm3*suma1/suma2;
		  cuenta3+=1;
		  }
	  }

 suma1=0;suma2=0;nm4=1;cuenta4=0;
  for (int i=1;i<=nyears;i++)
  {
	  if (sum(pobs_flom(i))>0)
	  {
		  suma1=sum(elem_prod(ppred_cruh(i),1-ppred_cruh(i)));
		  suma2=norm2(pobs_cruh(i)-ppred_cruh(i));
		  nm4=nm4*suma1/suma2;
		  cuenta4+=1;
		  }
	  }


 report << "Tamanho muestra ideal" <<endl;
 report <<pow(nm1,1/cuenta1)<< endl;
 report <<pow(nm2,1/cuenta2)<< endl;
 report <<pow(nm3,1/cuenta3)<< endl;
 report <<pow(nm4,1/cuenta4)<< endl;

 /*
 FUNCTION Eval_mcmc
  if(reporte_mcmc == 0)
  mcmc_report<<"Bcru_last CTP1 CTP2 CTP3 CTP4 BDp1/BDlast BDp2/BDlast BDp3/BDlast BDp4/BDlast "<<endl;
  mcmc_report<<pred_Bcru(nyears)<<" "<<YTP(1,1)<<" "<<YTP(1,2)<<" "<<YTP(1,3)<<" "<<YTP(1,4)<<
     " "<<SSBp(nyear_proy,1)/BD(nyears)<<" "<<SSBp(nyear_proy,2)/BD(nyears)<<" "<<SSBp(nyear_proy,3)/BD(nyears)<<
     " "<<SSBp(nyear_proy,4)/BD(nyears)<<endl;

  reporte_mcmc++;
 */
 
  /*
 FINAL_SECTION

 time(&finish);
 elapsed_time=difftime(finish,start);
 hour=long(elapsed_time)/3600;
 minute=long(elapsed_time)%3600/60;
 second=(long(elapsed_time)%3600)%60;
 cout<<endl<<endl<<"*********************************************"<<endl;
 cout<<"--Start time:  "<<ctime(&start)<<endl;
 cout<<"--Finish time: "<<ctime(&finish)<<endl;
 cout<<"--Runtime: ";
 cout<<hour<<" hours, "<<minute<<" minutes, "<<second<<" seconds"<<endl;
 cout<<"*********************************************"<<endl;


 // Comentados..

 // vector Brec(1,nyears)
 // vector pred_CPUE(1,nyears);
 // vector pred_Bcru(1,nyears);
 // vector pred_Desemb(1,nyears);
 // vector prior(1,7)
 //vector Lobs(1,nyears);
 //vector Lpred(1,nyears);
 // matrix NM(1,nyears,1,nedades)
 // matrix Nrec(1,nyears,1,ntallas)
 //matrix P1(1,nedades,1,ntallas) 
 //matrix P2(1,nedades,1,ntallas)
 //matrix P3(1,nedades,1,ntallas)
 // matrix NMDv(1,nyears,1,nedades)
 // number So
  */