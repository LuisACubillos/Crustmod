//##############################################################################
// MODELO EDAD ESTRUCTURADO CON DATOS DE TALLAS(5 GRUPOS DE EDAD)
// modelo CTP 2018_COTE
//##############################################################################
GLOBALS_SECTION
	#include <admodel.h>
	#include <stdio.h>
	#include <time.h>
    time_t start,finish;
    long hour,minute,second;
    double elapsed_time; 	
	ofstream mcmc_report("mcmc.txt");
	adstring simname;
    //Nombre de archivo gradiente
    ofstream rep_grad("00rep_convergencia.txt",ios::app);
    //Nombre de archivos para las variables de estado del simulador 
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
	adstring simname;
	//Nombre de archivo gradiente	
    ofstream rep_grad("02rep_converg_mcmc.txt",ios::app);
	//Escribe los archivos de estatus del Modelo Operativo (simulador)
	ofstream obyr_out("03byr_mop.txt",ios::app);
	ofstream osyr_out("04syr_mop.txt",ios::app);
	ofstream oryr_out("05ryr_mop.txt",ios::app);
	ofstream oro_out("06ro_mop.txt",ios::app);
	ofstream ofyr_out("07fyr_mop.txt",ios::app);	
	//Escribe los archivos de estatus del estimador
	ofstream ebyr_out("03byr_estimador.txt",ios::app);
	ofstream esyr_out("04syr_estimador.txt",ios::app);
	ofstream eryr_out("05ryr_estimador.txt",ios::app);
	ofstream ero_out("06ro_estimador.txt",ios::app);
	ofstream efyr_out("07fyr_estimador.txt",ios::app);
    */
	#undef rep
	#define rep(object) report << #object "\n" << object << endl;	
	#undef depur
	#define depur(object) cout << #object "\n" << object << endl; exit(1);
	
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
    return fileName(1,i-1);}}
    return fileName;
    }  

TOP_OF_MAIN_SECTION
  arrmblsize=50000000; ; // 
  gradient_structure::set_GRADSTACK_BUFFER_SIZE(1.e7); 
  gradient_structure::set_CMPDIF_BUFFER_SIZE(1.e7); 
  gradient_structure::set_MAX_NVAR_OFFSET(5000);
  gradient_structure::set_NUM_DEPENDENT_VARIABLES(5000);

DATA_SECTION
   int iseed;//generador de numeros aleatoreos
   !!long int lseed=iseed;
   !!CLASS random_number_generator rng(iseed);
   
   //se ancla al archivo .dat que guia a los datos
   init_adstring DataFile;
   init_adstring ControlFile;   
   !! BaseFileName = stripExtension(ControlFile);
   //verificar este leyendo bien los datos de entrada 
   !! cout << "dat: " << " " << DataFile << endl;
   !! cout << "ctl: " << " " << ControlFile << endl;
   !! cout << "basefileName: " << " " << BaseFileName << endl;
   !! ReportFileName = BaseFileName + adstring(".rep");
   !! ad_comm::change_datafile_name(DataFile);   
  
  init_int nanos  
  init_int nedades
  init_number edad_ini
  init_number delta_edad
  init_int ntallas
  init_matrix indices(1,nanos,1,7)
  init_matrix Cl(1,nanos,1,ntallas)
  init_matrix Nlcruceros(1,nanos,1,ntallas)
  matrix Wmed(1,nanos,1,ntallas)
  //Opciones desviaciones en q
  init_ivector opt_devq(1,nanos)
  init_ivector opt_devqCPUE(1,nanos)
  init_ivector opt_Sel2(1,nanos)
  int reporte_mcmc

 !! ad_comm::change_datafile_name(ControlFile);
  init_vector Tallas(1,ntallas)
  init_vector peso(1,ntallas)
  init_vector msex(1,ntallas)
  //Controles
  init_vector cvar(1,8)
  //!!cout << "CVAR " << cvar << endl;exit(1);
  init_vector nmus(1,2)
  init_int    opt_qCru
  init_int    opt_qCPUE
  init_int    opt_Sel1
  init_int    opt_Sel3
  init_int    opt_Sel4
  init_int    opt_Sel5
  // !!cout << "opt_Sel5 " << opt_Sel5 << endl;exit(1); 
  init_vector parbiol(1,5)
  //!!cout << "parms "<< parbiol << endl;exit(1);
  init_int    opt_VB1
  //!!cout << "opt_VB1 "<< opt_VB1 << endl;exit(1);
  init_int    opt_VB2
  init_int    opt_VB3
  init_int    opt_VB4
  init_int    opt_VB5
  init_int    opt_Rmed
  init_int    opt_devR
  init_int    opt_devNo
  init_int    opt_F
  init_int    opt_M
  //!!cout << "opt_M "<< opt_M << endl;exit(1); 
  init_int    nanos_proy
  init_int    npbr
  init_number RPRobj
  init_number Fobj
  init_int hyper; //0=sin hiper regla; 1=con hiper regla
  //!!cout << "Fobj "<< Fobj << endl;exit(1); 

INITIALIZATION_SECTION
// defino un valor inicial de log_reclutamiento promedio (factor de escala)
  log_Rmed         6
  log_F            -1.0
  log_A50f_one     1.09
  log_Df_one       0
  log_A50cru       1.09
  log_Dcru         0
  log_sf            0
  log_sda           0.40
  log_sda2          0.40
  log_qCru          0
  dev_log_A50f      0
  dev_log_Df        0
  log_Lo            2.9


PARAMETER_SECTION

// parametros selectividad
 init_bounded_number log_A50f_one(0.7,1.6,opt_Sel1)  
 init_bounded_number log_Df_one(0,0.7,opt_Sel1)
 
// desvios de los parametros selectividad flota
 init_number_vector dev_log_A50f(1,nanos,opt_Sel2)  
 init_number_vector dev_log_Df(1,nanos,opt_Sel2)

// parametros selectividad doble normal
 init_bounded_number log_muf(-9,1.24,opt_Sel3)
 init_bounded_vector log_sf(1,2,-10,3,opt_Sel3)

// parametros selectividad unica Cruceros
 init_bounded_number log_A50cru(0.6,1.7,opt_Sel4)  
 init_bounded_number log_Dcru(0,0.7,opt_Sel4)

// Recruits and F mortalities
// parametros reclutamientos y mortalidades)
 init_number log_Rmed(opt_Rmed)
 init_bounded_vector log_desv_No(1,nedades,-10,10,opt_devNo)
 init_bounded_vector log_desv_Rt(1,nanos-1,-10,10,opt_devR)
 init_bounded_vector log_F(1,nanos,-20,1.5,opt_F) // log  mortalidad por pesca por flota
 init_bounded_number log_M(-3,1.5,opt_M)
 
// capturabilidades
 init_number log_qCru(opt_qCru)
 init_number log_qCPUE(opt_qCPUE)
 init_number_vector devq(1,nanos-1,opt_devq)
 init_number_vector devqCPUE(1,nanos-1,opt_devqCPUE)

// crecimiento
 init_bounded_number log_Lo(2.8,3.2,opt_VB1)
 init_bounded_number log_cva(-3.9,-0.7,opt_VB2)
 init_bounded_number log_sda(-2.9,1.2,opt_VB3)
 init_bounded_vector log_sda2(1,nedades,-2.9,1.2,opt_VB4)
 init_bounded_number log_k(-1.5,-0.5,opt_VB5)

//Defino las variables de estado 
 vector ano(1,nanos)
 vector Desemb(1,nanos)
 //vector Desemb_pred(1,nanos);
 vector Bcrucero(1,nanos)
 //vector Bcrucero_pred(1,nanos);
 
 vector CPUE(1,nanos)
 vector cv1(1,nanos)
 vector cv2(1,nanos)
 vector cv3(1,nanos)
 vector Unos_edad(1,nedades)
 vector Unos_tallas(1,ntallas)
 vector Unos_ano(1,nanos)
 vector mu_edad(1,nedades);
 vector sigma_edad(1,nedades);
 vector Bcru(1,nanos);
 vector prior(1,10);
 //vector CPUE_pred(1,nanos);
 vector Neq(1,nedades);
 vector Neqv(1,nedades);
 vector likeval(1,10);
 vector SDo(1,nanos);
 number SDo2;

 vector edades(1,nedades)
 vector Scru_1(1,nedades);
 vector Scru_2(1,nedades);
 vector log_A50f(1,nanos)
 vector log_Df(1,nanos)
 vector log_A50R2(1,nanos)
 vector log_DR2(1,nanos)
 vector qCru(1,nanos)
 vector qCPUE(1,nanos)

 matrix Sflo(1,nanos,1,nedades)
 matrix Scru(1,nanos,1,nedades)
 matrix F(1,nanos,1,nedades)
 matrix Z(1,nanos,1,nedades)
 matrix S(1,nanos,1,nedades)
 matrix N(1,nanos,1,nedades)
 matrix NM(1,nanos,1,nedades)
 matrix Nv(1,nanos,1,nedades)
 matrix Cedad(1,nanos,1,nedades)
 matrix Prob_talla(1,nedades,1,ntallas)
 matrix P1(1,nedades,1,ntallas)
 matrix P2(1,nedades,1,ntallas)
 matrix P3(1,nedades,1,ntallas)
 matrix Cl_pred(1,nanos,1,ntallas)
 matrix Nlcruceros_pred(1,nanos,1,ntallas)
 matrix pobs(1,nanos,1,ntallas)
 matrix ppred(1,nanos,1,ntallas)
 matrix pobs_cru(1,nanos,1,ntallas)
 matrix ppred_cru(1,nanos,1,ntallas)

 number suma1
 number suma2
 number suma3
 number suma4
 number pStotf
 number pSf
 number penalty

 number Linf
 number k
 number cv_edad
 number sd_edad
 number Lo
 number M
 number Nvplus
 number Npplus


// los arreglos usados en la proyeccion

  number Yp
  number factor
  vector temp0(1,nedades)
  vector temp1(1,nedades)
  number Fx
  vector Wedad(1,nedades)



 vector Np(1,nedades)
 vector NMp(1,nedades)
 vector Sp(1,nedades)
 vector Fp(1,nedades)
 vector Zp(1,nedades)
 vector Cap(1,ntallas)

 //matrix YTP(1,npbr,nanos+1,nanos+nanos_proy) //TODO
 matrix Bp(1,npbr,nanos+1,nanos+nanos_proy)
 matrix SDp(1,npbr,nanos+1,nanos+nanos_proy)
 matrix Fpbr(1,npbr,nanos+1,nanos+nanos_proy)

 vector Nvp(1,nedades)
 vector Sfp(1,nedades)
 vector SDvp(nanos+1,nanos+nanos_proy)
 
 sdreport_vector CPUE_pred(1,nanos);
 vector Bcrucero_pred(1,nanos);
 sdreport_vector Desemb_pred(1,nanos);
 sdreport_vector SD(1,nanos) // 
 sdreport_vector RPR(1,nanos) // 
 sdreport_vector RPR2(1,nanos) // 
 sdreport_vector Reclutas(1,nanos-1)
 sdreport_number Flast
 vector CTP(1,npbr)
 //vector RPRp(1,npbr)
 vector Btot(1,nanos)
 vector Bv(1,nanos)

 //
 number Ro
 number So
 number h
 number alpha
 number beta
 vector Rpred(1,nanos)
 vector Fyr(1,nanos)
 number Fref
 number RPRp
 number Rp
	 
	 //PARA EL MODELO OPERATIVO
 	 vector wt(1,nedades)
	 vector wt_fut(1,nedades)
	
	 vector pm(1,nedades)
	 vector Scp(1,nedades)
	 number log_q_cpue
	 number log_q_bacu 	 
 
 
    number mu_ref;
    vector yrs_fut(nanos+1,nanos+nanos_proy); 
    number Kobs_tot_catch;	 
 	matrix C_fut(1,npbr,nanos+1,nanos+nanos_proy);
	matrix cba_fut(1,4,nanos+1,nanos+nanos_proy);
 	//matrix YTP(1,npbr,1,nanos+nanos_proy);
	number YTP;	
 	vector bvuln_fut(nanos+1,nanos+nanos_proy);
    vector N_fut(1,nedades);
 	matrix F_fut(nanos+1,nanos+nanos_proy,1,nedades);
 	matrix check_convergence(1,npbr,nanos+1,nanos+nanos_proy);
 	vector Fyr_fut(nanos+1,nanos+nanos_proy);
    vector NVflo_fut(1,nedades);
	vector NVcru_fut(1,nedades);
    vector BMflo_fut(nanos+1,nanos+nanos_proy);
	vector BMcru_fut(nanos+1,nanos+nanos_proy);
  	matrix catage_fut(nanos+1,nanos+nanos_proy,1,nedades);
 	matrix catlen_fut(nanos+1,nanos+nanos_proy,1,ntallas);
    matrix Nlcruceros_fut(nanos+1,nanos+nanos_proy,1,ntallas);
	vector nlcru(1,ntallas);
 	matrix crulen_fut(nanos+1,nanos+nanos_proy,1,ntallas)
	vector S_fut(1,nedades);
	vector Wmed_fut(1,ntallas);
	number BDp;
    vector Z_fut(1,nedades);
    matrix F_tmp(nanos+1,nanos+nanos_proy,1,nedades);
	number qCru_fut;

 	

 
 	
 	//matrix Z_fut(nanos+1,nanos+nanos_proy,1,nedades);
 	//matrix S_fut(nanos+1,nanos+nanos_proy,1,nedades);
	
 	matrix cru_age_fut(nanos+1,nanos+nanos_proy,1,nedades);
 	vector B_fut(nanos+1,nanos+nanos_proy);
 	vector ssb_fut(nanos+1,nanos+nanos_proy);
 	vector sim_cpue(nanos+1,nanos+nanos_proy);
 	vector sim_bacu(nanos+1,nanos+nanos_proy);
 	vector rec_epsilon(nanos+1,nanos+nanos_proy);
 	vector cpue_epsilon(nanos+1,nanos+nanos_proy);
 	vector bacu_epsilon(nanos+1,nanos+nanos_proy);
	
    vector bcru_fut(nanos+1,nanos+nanos_proy);
	
	matrix bcrucero_fut(1,npbr,nanos+1,nanos+nanos_proy);
		
 	vector fut_B(nanos+1,nanos+nanos_proy);
 	vector fut_ssb(nanos+1,nanos+nanos_proy);
	vector fut_SD(nanos+1,nanos+nanos_proy);
 	vector fut_bvuln(nanos+1,nanos+nanos_proy);
 	vector rpr(nanos+1,nanos+nanos_proy);  
	 //Para guardar los indices de estatus del estimador y evaluar desempeño del estimador
 	matrix keep_Btot(1,npbr,nanos+1,nanos+nanos_proy);
 	matrix keep_SSBt(1,npbr,nanos+1,nanos+nanos_proy);
 	matrix keep_Rt(1,npbr,nanos+1,nanos+nanos_proy);
 	matrix keep_Ro(1,npbr,nanos+1,nanos+nanos_proy);
 	matrix keep_Ft(1,npbr,nanos+1,nanos+nanos_proy);
	//Para guardar los indices equivalentes del Mod Operativo y evaluar desempeño del estimador
	matrix des_Btot(1,npbr,nanos+1,nanos+nanos_proy);
	matrix des_SSBt(1,npbr,nanos+1,nanos+nanos_proy);
 	matrix des_Rt(1,npbr,nanos+1,nanos+nanos_proy);
 	matrix des_Ro(1,npbr,nanos+1,nanos+nanos_proy);
 	matrix des_F(1,npbr,nanos+1,nanos+nanos_proy);

	objective_function_value f


PRELIMINARY_CALCS_SECTION
 // leo la matriz de indices

  ano=column(indices,1);// asigno la 1 columna de indices a "años"
  Bcrucero=column(indices,2);
  cv1=column(indices,3);
  CPUE=column(indices,4);
  cv2=column(indices,5);
  Desemb=column(indices,6);
  cv3=column(indices,7);

  Unos_edad=1;// lo uso en  operaciones matriciales con la edad
  Unos_ano=1;// lo uso en operaciones matriciales con el año
  Unos_tallas=1;// lo uso en operaciones matriciales con el año
  
  reporte_mcmc=0;
  h = parbiol(5);
  //GENERA MATRIZ DE PESOS MEDIOS A LA TALLA CONSTANTES
  for(int i=1;i<=nanos;i++)
  {
		  Wmed(i)=peso;
  }
  //cout << "Hasta aqui" << endl;exit(1);
  //cout << "Wmed" << Wmed << endl;exit(1);

RUNTIME_SECTION
  maximum_function_evaluations 200,1000,3000,5000
  convergence_criteria  1e-3,1e-5,1e-5,1e-6


PROCEDURE_SECTION
  // para comentar mas de una lina  /*.........*/
  // se listan las funciones que contienen los calculos
	  
  Eval_selectividad();
  Eval_mortalidades();
  Eval_abundancia();
  Eval_prob_talla_edad();
  Eval_capturas_predichas();
  Eval_deinteres();
  Eval_logverosim();
  Eval_funcion_objetivo();
  
  //if(mceval_phase()){
	//  	    Operative_model();}
  
FINAL_SECTION
	Operative_model(); //(util para ver si funciona codigo solo con 1 estimacion ) APAGAR ESTO URGENTE AHORA PARA QUE CORRA BIEN

  
FUNCTION Operative_model  
  	 
	 //cout << "aqui !!!!!!!!!!!!!!!! " << endl;exit(1);
	 log_q_bacu=log(qCru(nanos));
	 log_q_cpue=log(qCPUE(nanos));
	 
	 //cout << "log_q_cpue " << log_q_cpue << endl;exit(1);	
	  
	 pm = Prob_talla*msex; 
	 wt = Prob_talla*peso;
	 //cout << "pm " << pm << endl;exit(1);
	 dvector ran_rec(nanos+1,nanos+nanos_proy); //numero aleatorio para el reclutamiento
	 dvector ran_cpue(nanos+1,nanos+nanos_proy);
	 dvector ran_bacu(nanos+1,nanos+nanos_proy);
	 int upk;  
     int k,l,j,i,a;//contador de los ciclos for
	 dvariable numyear=1968;
	 dvector yrs(nanos+1,nanos+nanos_proy);
	 simname="lcsur_est.dat"; //nombre de los datos del estimador
	 dvector CatchNow(1,4); //Aqui son 4 estrategias modelo-dependiente desde el estimador
	
	 dvector  eval_now(1,5);
	 dvariable grad_tmp;
	
	 //cout << "wt" << wt << endl; exit(1);
	 
     //dvariable sigr;
     //sigr=sigmaR;
	 
     ran_rec.fill_randn(rng);//error de proceso
     ran_cpue.fill_randn(rng);//error de ob
     ran_bacu.fill_randn(rng);//error de ob
     int rv;  
 
     for(int l=1;l<=npbr;l++){
   	    rv=system("./paso1.sh"); 
    
	 N_fut= N(nanos);
	 //cout << "N_fut" << N_fut << endl; exit(1);
     S_fut= S(nanos);
	 //cout << "S_fut" << S_fut << endl; exit(1);
     BDp=SD(nanos); //duda     
     Z_fut=Z(nanos);
	 Sfp=Sflo(nanos);
	 Scp=Scru(nanos);
	 wt_fut = wt; //por edad
	 Wmed_fut = Wmed(nanos); //por tallas
	 qCru_fut=qCru(nanos);
	 //qCru_fut= qCru(nanos);
	 //cout << "wt_fut" << wt_fut << endl; exit(1);	 
	     //Win_fut=Win(nanos);
     //Scru_fut=Sel_reclas(nanos);
     //Scru_pela_fut=Sel_pelaces(nanos);
     //Wm_fut=Wmed(nanos);
     //sel=Sel_flota(nanos);
     
     for(i=nanos+1;i<=nanos+nanos_proy;i++)
     { 
		rec_epsilon(i)=ran_rec(i)*cvar(2); //revisar esos cvar calcular sigma desde los reclutamiento estimados
 		cpue_epsilon(i)=exp(ran_cpue(i)*cv2(nanos));
 		bacu_epsilon(i)=exp(ran_bacu(i)*cv1(nanos));
 		//Lee la CTP del estimador
 		ifstream CTP_tmp("tac.dat");
 		CTP_tmp >> CatchNow;
 		CTP_tmp.close();  
		 //guarda la captura modelo-basada
		
		//cout << "C_fut "<< C_fut << endl;exit(1);
		
        N_fut(2,nedades)= ++elem_prod(N_fut(1,nedades-1),S_fut(1,nedades-1));
        N_fut(1)=((BDp/(alpha+beta* BDp)))* exp(rec_epsilon(i)) + 0.5* square(cvar(2));
		
		NVflo_fut= elem_prod(N_fut,Sfp);
		//NVcru_fut= elem_prod(N_fut,Sfc);
	   
	    Nlcruceros_fut(i)= elem_prod(N_fut,Scp)*Prob_talla;
		nlcru = Nlcruceros_fut(i);
	
	 
        B_fut(i)=0;
        bvuln_fut(i)=0;
		for(int j=1;j<=nedades;j++){ 
		B_fut(i)+= wt_fut(j)*N_fut(j);
	    bvuln_fut(i)+= wt_fut(j)* NVflo_fut(j);}
	   
	    bcru_fut(i)=qCru_fut*sum((elem_prod(nlcru,Wmed_fut)))*bacu_epsilon(i);// biomasas al crucero 
		
		//cout << "Nlcruceros_fut_2 "<< bcru_fut << endl;
		
		bcrucero_fut(l,i)=(bcru_fut(i));
		
		//REGLAS MODELO-DEPENDIENTES
		if(l==1){
			
			cba_fut(l,i)=CatchNow(l);
			YTP = cba_fut(l,i);
		}
		if(l==2){
			cba_fut(l,i)=CatchNow(l);
			YTP = cba_fut(l,i);
		}
		if(l==3){
			cba_fut(l,i)=CatchNow(l);
			YTP = cba_fut(l,i);
		}
		if(l==4){
			cba_fut(l,i)=CatchNow(l);
			YTP = cba_fut(l,i);
		}
		//cout << "Nlcruceros_fut_2 "<< bcrucero_fut << endl;exit(1);
		//YTP=0;
			if(l==5){
			mu_ref=0.3;
			YTP =mu_ref*bcru_fut(i);}
		     if(l==6){
			 mu_ref = 0.2;
			 YTP =mu_ref*bcru_fut(i);}
			 
		      //Captura en peso empirica mu es la tasa de explotacion
		 if(l==7){
			if(bcru_fut(i) < 28335){ //Bprom
			YTP=(0.167*(bcru_fut(i)))*((bcru_fut(i)/28335)-0.25)/0.75; //Cprom/Bprom
			if(bcru_fut(i) < 7084){
			YTP=0;
			}}else{	
			YTP=4734;
			}
		    }
			if(l==8){
				 if(bcru_fut(i) < 28335){ //Bprom
					 YTP=0.167*bcru_fut(i);  //Cprom/Bprom
				 }else{YTP=4734;}
				 }
			
			//HYPERREGLA
			if(hyper==1){
			if(i == nanos+1){
				 if(YTP > 1.15*Desemb(nanos)){YTP = 1.15*Desemb(nanos);}}else{if(YTP > 1.15*C_fut(l,i-1)){YTP = 1.15*C_fut(l,i-1);}}
			}
			
   		C_fut(l,i)=YTP; //guarda la captura con estrategia actual
	    //cout << C_fut << endl; exit(1); 
       //se realiza una exploracion aleatorea 
		if(C_fut(l,i)!=0){
	    //Para estimar la mortalidad por pesca dado el TAC y N_fut
	    dvariable ffpen=0.0;
	    dvariable SK=posfun((bvuln_fut(i)-C_fut(l,i))/bvuln_fut(i),0.05,ffpen);
	    Kobs_tot_catch=bvuln_fut(i)-SK*bvuln_fut(i);
		do_Newton_Raphson_for_mortality(i);				
	    F_fut(i)=F_tmp(i);}	
	    else			
	    {
	    F_fut(i)=0;
	    }
		
					
		//cout << "F_fut" << F_fut << endl; exit(1);
		Z_fut=F_fut(i)+M;
		
		
		
		S_fut=exp(-1*Z_fut);
	    Fyr_fut(i)=max(F_fut(i)); //incorporado por cote
		
		
		fut_B=B_fut(i);
		
		
		
		//Fyr_fut=max(F_fut(i));
        //Recalcula los indicadores despues que la mortalidad fue calculada 
		NVflo_fut= elem_prod(elem_prod(N_fut,mfexp(-0.5*Z_fut)),Sfp);//explotable
		NVcru_fut= elem_prod(elem_prod(N_fut,mfexp(-0.5*Z_fut)),Scp); //vulnerable crucero
		BMflo_fut(i)=wt_fut* NVflo_fut;//biom explotable
		BMcru_fut(i)=wt_fut*NVcru_fut;//biom vulnerable
        //fut_ssb(i)=N_fut*wt_fut*exp(-0.67*Z_fut);
		fut_SD(i)=sum(elem_prod(elem_prod(elem_prod(N_fut,exp(-0.67*Z_fut))*Prob_talla,Wmed_fut),msex));
		BDp = fut_SD(i);

		//Funcion de desempeño
		//rpr(i)=fut_ssb(i)/So;
		//Indices simulados cpue y bacu SIMULA LOS DATOS PARA ACTUALIZAR LA EVALUACION CON EL ESTIMADOR
		sim_cpue(i)=exp(log_q_cpue)*BMflo_fut(i)*cpue_epsilon(i);
		sim_bacu(i)=exp(log_q_bacu)*BMcru_fut(i)*bacu_epsilon(i);
		bcrucero_fut(l,i)=sim_bacu(i);
		
		//Ahora simula la composicion por edad y por talla			
		for(int j=1;j<=nedades;j++){
		catage_fut(i,j)=F_fut(i,j)*N_fut(j)*(1-S_fut(j))/Z_fut(j);
		cru_age_fut(i,j)=Scp(j)*N_fut(j)*(1-S_fut(j))/Z_fut(j);				
		}
		
		catlen_fut(i)=catage_fut(i)*Prob_talla;
		
		
		crulen_fut(i)=cru_age_fut(i)*Prob_talla;
		
		//cout << "aqui_4 "<< crulen_fut<< endl;exit(1);
		
		
	    upk=i;
	    yrs_fut(i)=numyear+i-1;		
		ofstream simdata(simname);
		simdata << "#DATOS SIMULADOS MODELO OPERATIVO" << endl;
		simdata << "#Numero de anos" << endl;
		simdata << upk << endl;
		simdata << "#Numero de edades" << endl;
		simdata << nedades << endl;
		simdata << "#Edad inicial" << endl;
		simdata << 1 << endl;
		simdata << "#Delta Edad" << endl;
		simdata << 1 << endl;
		simdata << "#Numero de tallas" << endl;
		simdata << ntallas << endl;
		simdata << "#Datos observados"<<endl;
		simdata << "#Yr Crucero cv CPUE cv Desembarque cv"<<endl;
		simdata << indices << endl;
		simdata << "#DATA SIMULADA FUTURA"<<endl;
		simdata << "#Yr Crucero cv1 CPUE cv Desembarque cv"<<endl;
		for(int k=nanos+1;k<=upk;k++)
		{
			simdata << yrs_fut(k) << " " << bcrucero_fut(l,k) << " " << cv1(nanos) << " " << sim_cpue(k) << " "<< cv2(nanos) << " " << C_fut(l,k)  << "  "<< cv3(nanos) << endl; 	
		}
		simdata << "#ESTRUCTURA DE TALLAS PESCA OBS"<<endl;
		simdata <<  Cl <<endl;
		simdata << "#estructura talla PESCA simulada" << endl;
		for(int k=nanos+1;k<=upk;k++)
		{
		simdata <<  catlen_fut(k) <<endl;
	    }
		simdata << "#ESTRUCTURA DE TALLAS CRUCERO OBS"<<endl;
		simdata <<  Nlcruceros <<endl;
		simdata << "#estructura talla CRUCERO simulada" << endl;
		for(int k=nanos+1;k<=upk;k++)
		{                                          
			simdata <<  crulen_fut(k) <<endl;
	    }
		simdata << "#Anos	y	fase	con	cambio	en	qCru	(si	>0)" << endl;
		simdata << opt_devq << endl;
		for(int k=nanos+1;k<=upk;k++)
		{
			simdata <<  -1 <<endl;
	    }
		simdata << "#Anos	y	fase	con	cambio	en	qCPUE	(si	>0)" << endl;
		simdata << opt_devqCPUE << endl;
		for(int k=nanos+1;k<=upk;k++)
		{
			simdata <<  -1 <<endl;
	    }
		simdata << "#Fase	desvios	en	la	selectividad	de	la	flota	(variable	si	>0)" << endl;
		simdata << opt_Sel2 << endl;
		for(int k=nanos+1;k<=upk;k++)
		{
			simdata <<  -1 <<endl;
	    }
		simdata << "#eof"<<endl;
		simdata.close();
		rv=system("./paso2.sh");
		//Lee los indicadores de estatus del estimador.  
		ifstream eval_estatus("estatus.dat");
		eval_estatus >> eval_now;
		eval_estatus.close();
		keep_Btot(l,i)=eval_now(1);//biomasa total 
		keep_SSBt(l,i)=eval_now(2);//biomasa desovante
		keep_Rt(l,i)=eval_now(3);//Reclutamiento
		keep_Ro(l,i)=eval_now(4);
		keep_Ft(l,i)=eval_now(5);//mortalidad por pesca
		//Guarda las cantidades equivalentes del MOP
		des_Btot(l,i)=fut_B(i); 
		des_SSBt(l,i)=fut_SD(i);
		des_Rt(l,i)=N_fut(1);
		des_Ro(l,i)=fut_SD(i)/SDo2;
		des_F(l,i)=Fyr_fut(i);
		ifstream lee_grad("grad_final.dat");
		lee_grad >> grad_tmp;
		lee_grad.close();
			if(grad_tmp>0.001)
			{
				check_convergence(l,i)=0;
			}
			else
				{
					check_convergence(l,i)=1;}
	}
	
	
			
 	}
 	
    //======== REPORTA SIMLACIONES Y ESTIMACIONES
    //Capturas efectivas		       
    rep1 << C_fut << endl;
    //Guarda variables de estado del simulador y estimador
    //Simulador
    rep2 << des_Btot << endl;
    rep3 << des_SSBt << endl;
    rep4 << des_Rt << endl;
    rep5 << des_F << endl;
    //rep15 << des_RBB <<endl;
 
    //Estimador
    rep6 << keep_Btot << endl;
    rep7 << keep_SSBt << endl;
    rep8 << keep_Rt << endl;
    rep9 << keep_Ft << endl;
    //rep14 << keep_RBB <<endl; 
    //Variables en la fase histórica
    rep10 << Fyr << endl; //mortalidad pesca         
    rep11 << SD << endl; //desovante
    rep12 << Btot << endl; //biomasa total
    rep13 << column(N,1) << endl; //Reclutas       DUDA 
	rep15 << RPR2 << endl; //RPR mop
    //rep16 << keep_Ro <<endl; //RPR est
    rep_grad << check_convergence << endl;
	rep17 << bcrucero_fut <<endl;
    
	


	//rep1 << Fyr_fut << endl;
	//rep2 << C_fut << endl;
	//rep3 << fut_ssb << endl;
	//rep4 << fut_bvuln << endl;
	//rep5 << B_fut << endl;
	//rep6 << rpr << endl;
	//rep_grad << check_convergence << endl;

	/*//PARA EVALUAR DESEMPEÑO: cantidades del estimador
	ebyr_out<< keep_Btot <<endl;
	esyr_out<< keep_SSBt <<endl;
	eryr_out<< keep_Rt << endl;
	ero_out << keep_Ro << endl;
	efyr_out<< keep_Ft << endl; 

	obyr_out<< des_Btot <<endl;
	osyr_out<< des_SSBt <<endl;
	oryr_out<< des_Rt << endl;
	oro_out << des_Ro << endl;
	ofyr_out<< des_Ft << endl; 
	*/
			
FUNCTION void do_Newton_Raphson_for_mortality(int i)
			  dvariable Fold = Kobs_tot_catch/bvuln_fut(i);
			  dvariable Fnew ;
			  for (int ii=1;ii<=5;ii++)
			  {
			      dvariable ZZ = Fold + M;
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
			  F_tmp(i)= Fnew*Sfp; 		
		
		
					
			

FUNCTION Eval_selectividad
  int i;

  edades.fill_seqadd(edad_ini,delta_edad);

  log_A50f(1)=log_A50f_one;
  log_Df(1)=log_Df_one;


  for (int i=2;i<=nanos;i++){
  log_A50f(i)=log_A50f(i-1)+dev_log_A50f(i-1);
  log_Df(i)=log_Df(i-1)+dev_log_Df(i-1);}


  Scru_1=elem_div(Unos_edad,(1+exp(-1.0*log(19)*(edades-exp(log_A50cru))/exp(log_Dcru))));

  for (i=1;i<=nanos;i++)
  {Sflo(i)=elem_div(Unos_edad,(1+mfexp(-1.0*log(19)*(edades-mfexp(log_A50f(i)))/mfexp(log_Df(i)))));
  Scru(i)=Scru_1;
  }

// parametros selectividad doble normal

  if(opt_Sel3>0){// selectividad doble_normal unica 
    for (i=1;i<=nanos;i++){
      Sflo(i)=mfexp(-1/(2*square(exp(log_sf(1))))*square((edades-exp(log_muf))));
      for (int j=1;j<=nedades;j++){
       if(edades(j)>exp(log_muf)){
       Sflo(i,j)=mfexp(-1/(2*square(exp(log_sf(2))))*square(-1.*(edades(j)-exp(log_muf))));}
    }}}
     
  if(opt_Sel5>0)// selectividad 1.0
      {Scru=1;}


FUNCTION Eval_mortalidades

  
  M=parbiol(4);

  if (active(log_M)){M=mfexp(log_M);}
  Fyr=mfexp(log_F);
  F=elem_prod(outer_prod(Fyr,Unos_edad),Sflo);
  Z=F+M;
  S=mfexp(-1.0*Z);

  Flast=mfexp(log_F(nanos));

FUNCTION Eval_abundancia
 int i, j;

// genero una estructura inicial de equilibrio como referencia para el primer año
  Neq(1)=mfexp(log_Rmed);
  Neqv(1)=mfexp(log_Rmed);

  for (j=2;j<=nedades;j++)
  { Neq(j)=Neq(j-1)*exp(-1.*Z(1,j-1));// stock eq
    Neqv(j)=Neqv(j-1)*exp(-1.*M);} // stock virginal en eq

    Neq(nedades)=Neq(nedades)/(1-exp(-1.*Z(1,nedades)));// grupo plus
    Neqv(nedades)=Neqv(nedades)/(1-exp(-1.*M));// grupo plus

   N(1)=mfexp(log(Neq)+log_desv_No);// Composición de ededades poblacion inicial

   Reclutas=mfexp(log_Rmed+log_desv_Rt);

// luego considero los reclutas anuales a la edad 2
  for (i=2;i<=nanos;i++)
  {N(i,1)=Reclutas(i-1);}

// se estima la sobrevivencia por edad(a+1) y año(t+1)
  for (i=1;i<nanos;i++)
  {N(i+1)(2,nedades)=++elem_prod(N(i)(1,nedades-1),S(i)(1,nedades-1));
   N(i+1,nedades)+=N(i,nedades)*S(i,nedades);
  }


FUNCTION Eval_prob_talla_edad

  Linf=parbiol(1);
  k=parbiol(2);
  Lo=parbiol(3);

  if (active(log_Lo)){Lo=mfexp(log_Lo);}
  if (active(log_k)){k=mfexp(log_k);}

 int i, j;
 
// genero una clave edad-talla para otros calculos. Se modela desde L(1)
  mu_edad(1)=Lo;

  for (i=2;i<=nedades;i++){
   mu_edad(i)=Linf*(1-exp(-k))+exp(-k)*mu_edad(i-1);
   }

    cv_edad=mfexp(log_cva);
    sigma_edad=cv_edad*mu_edad;  // proporcional con la talla por defecto
 
  if (active(log_sda)){
    sigma_edad=mfexp(log_sda);}// constante

  if (active(log_sda2)){// independiente
   sigma_edad=mfexp(log_sda2);
    }

//---------------------------------------------------------------
  for (i=1;i<=nedades;i++){
    P1(i)=(Tallas-mu_edad(i))/sigma_edad(i);

  for (j=1;j<=ntallas;j++){
    P2(i,j)=cumd_norm(P1(i,j));}}
   
  for (i=1;i<=nedades;i++){
     for (j=2;j<=ntallas;j++){
       P3(i,j)=P2(i,j)-P2(i,j-1);}}

  Prob_talla=elem_div(P3+1e-16,outer_prod(rowsum(P3+1e-16),Unos_tallas));


FUNCTION Eval_capturas_predichas

// matrices de capturas predichas por edad y año
  Cedad=elem_prod(elem_div(F,Z),elem_prod(1.-S,N));

// matrices de capturas predichas por talla y año
  Cl_pred=Cedad*Prob_talla;

// matrices de cruceros predichas por talla y año
  NM=elem_div(elem_prod(N,1-S),Z);   
  Nlcruceros_pred=elem_prod(NM,Scru)*Prob_talla;
 
// matrices de proporcion de capturas por talla y año
  pobs=elem_div(Cl,outer_prod(rowsum(Cl),Unos_tallas)+1e-5);
  ppred=elem_div(Cl_pred,outer_prod(rowsum(Cl_pred),Unos_tallas));

// Cruceros
  pobs_cru=elem_div(Nlcruceros,outer_prod(rowsum(Nlcruceros),Unos_tallas)+1e-5);
  ppred_cru=elem_div(Nlcruceros_pred,outer_prod(rowsum(Nlcruceros_pred),Unos_tallas)+1e-5);

// vectores de desembarques predichos por año
  Desemb_pred=rowsum((elem_prod(Cl_pred,Wmed)));


FUNCTION Eval_deinteres


// Rutina para calcular RPR
  Nv=N;// solo para empezar los calculos

 for (int i=1;i<nanos;i++)
  {
      Nv(i+1)(2,nedades)=++Nv(i)(1,nedades-1)*exp(-1.0*M);
      Nv(i+1,nedades)+=Nv(i,nedades)*exp(-1.0*M);}

  Btot=rowsum((elem_prod(N*Prob_talla,Wmed)));
  Bcru=rowsum((elem_prod(Nlcruceros_pred,Wmed)));;// biomasas al crucero 
  Bv=rowsum(elem_prod(elem_prod(NM,Sflo)*Prob_talla,Wmed));
  

// Estimacion de B.cruceros

   qCru(1)=mfexp(log_qCru);
   qCPUE(1)=mfexp(log_qCPUE);

   for (int i=2;i<=nanos;i++)
   {qCru(i)=qCru(i-1)*mfexp(devq(i-1));
    qCPUE(i)=qCPUE(i-1)*mfexp(devqCPUE(i-1));}

   Bcrucero_pred=elem_prod(qCru,Bcru);


  SD=rowsum(elem_prod(elem_prod(elem_prod(N,exp(-0.67*Z))*Prob_talla,Wmed),outer_prod(Unos_ano,msex)));// desovantes al 1 agosto
  SDo=rowsum(elem_prod(elem_prod(Nv*exp(-0.67*M)*Prob_talla,Wmed),outer_prod(Unos_ano,msex)));// sin pesca al 1 agosto

//  SDo2=sum(elem_prod(elem_prod((Neqv*exp(-0.67*M))*Prob_talla,msex),colsum(Wmed)/nanos));// virginal al 1 agosto
  SDo2=sum(elem_prod(elem_prod((Neqv*exp(-0.67*M))*Prob_talla,msex),Wmed(nanos)));// virginal al 1 agosto


  RPR=elem_div(SD,SDo);
  RPR2=SD/SDo2;

  CPUE_pred=elem_prod(qCPUE,Bv);
  
  //=======================================================
  //Relacion stock-recluta
  Ro = exp(log_Rmed);
  So = SDo2;
  alpha = (So*(1-h))/(4*h*Ro);
  beta = (5*h-1)/(4.0*h*Ro);
  Rpred = elem_div(SD,alpha+(beta*SD));
  


FUNCTION Eval_logverosim
// esta funcion evalua el nucleo de las -log-verosimilitudes marginales para
// series con datos 0.
  int i;

  suma1=0; suma2=0; 

  for (i=1;i<=nanos;i++)
  {
   if (Bcrucero(i)>0){
    suma1+=square((log(Bcrucero(i))-log(Bcrucero_pred(i)))/cv1(i));}
   if (CPUE(i)>0){
    suma2+=square((log(CPUE(i))-log(CPUE_pred(i)))/cv2(i));}
  }


FUNCTION Eval_funcion_objetivo

  int i,j;

// se calcula la F.O. como la suma de las -logver
// lognormalgraf
  likeval(1)=0.5*suma1;//Cruceros
  likeval(2)=0.5*suma2;//CPUE
  likeval(3)=0.5*norm2(elem_div(log(Desemb)-log(Desemb_pred),cv3));//Desembarques  

// multinomial flota
  likeval(4)=-1.*nmus(1)*sum(elem_prod(pobs,log(ppred)));

// multinomial cruceros
  likeval(5)=-1.*nmus(2)*sum(elem_prod(pobs_cru,log(ppred_cru)));


// Priors
// lognormal Ninicial y Reclutas
  prior(1)=0.5*norm2((log(row(N,1))-log(Neq))/cvar(1));
  prior(2)=0.5*norm2(log_desv_Rt/cvar(2));

  if (active(log_k)){// si estima k
  prior(3)=0.5*square((log_k-log(parbiol(2)))/cvar(3));}

  if (active(log_qCru)){
  prior(4)=0.5*square(log_qCru/cvar(4));}

  if(max(opt_Sel2)>0){
  prior(5)=0.5*norm2(dev_log_A50f/cvar(5));}

  if (active(log_M)){
  prior(6)=0.5*square((log_M-parbiol(4))/cvar(6));}

  if (max(opt_devq)>0){
  prior(7)=0.5*norm2(devq/cvar(7));}

  if (max(opt_devqCPUE)>0){
  prior(8)=0.5*norm2(devqCPUE/cvar(8));}

  

   f=sum(likeval)+sum(prior);



REPORT_SECTION
  
  rep(ano);
  rep(Bcrucero);
  rep(Bcrucero_pred);
  rep(Desemb);
  rep(Desemb_pred);
  rep(CPUE);
  rep(CPUE_pred);
  rep(Btot);
  rep(SD);
  rep(Bv);
  rep(RPR2);
  rep(N);
  rep(Neq);
  rep(F);
  rep(Sflo);
  rep(pobs);
  rep(ppred);
  rep(pobs_cru);
  rep(ppred_cru);
  rep(Scru);
  rep(Tallas);
  rep(likeval);
  rep(Linf);
  rep(k);
  rep(Lo);
  rep(edades);
  rep(mu_edad);
  rep(sigma_edad);
  rep(msex);
  rep(qCru);
  rep(SDo2);
  rep(Prob_talla);
  rep(M);
  rep(So);
  rep(Ro);
  rep(Rpred);
  rep(h);
  rep(alpha);
  rep(beta);
  rep(Fyr);

  /*
 FUNCTION Eval_mcmc
  if(reporte_mcmc == 0)
  mcmc_report<<"Bcru CTP1 CTP2 CTP3 CTP4 CTP5 BDp1_fin BDp2_fin BDp3_fin BDp4_fin BDp5_fin"<<endl;
  mcmc_report<<Bcrucero_pred(nanos)<<" "<<YTP(1,1)<<" "<<YTP(1,2)<<" "<<YTP(1,3)<<" "<<YTP(1,4)<<" "<<YTP(1,5)<<
     " "<<SDp(nanos_proy,1)<<" "<<SDp(nanos_proy,2)<<" "<<SDp(nanos_proy,3)<<
     " "<<SDp(nanos_proy,4)<<" "<<SDp(nanos_proy,5)<<endl;

  reporte_mcmc++;
  */

  /*GLOBALS_SECTION
  #include  <admodel.h>
  ofstream mcmc_report("mcmc.txt");
	#undef rep
	#define rep(object) report << #object "\n" << object << endl;	
	#undef depur
	#define depur(object) cout << #object "\n" << object << endl; exit(1);

   // ofstream rep1("01fmort_mcmc_p.txt",ios::app); //Mortalidad por pesca futura
   // ofstream rep2("02captura_mcmc_p.txt",ios::app); //Capturas futuras
   // ofstream rep3("03biodesov_mcmc_p.txt",ios::app); //biomasa desovante
   */