#grupos	de	talla
9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40	41	42	43	44	45	46	47	48	49	50	51
#peso a la talla
0.540	0.722	0.941	1.198	1.497	1.841	2.232	2.673	3.168	3.718	4.327	4.997	5.732	6.533	7.404	8.347	9.366	10.462	11.638	12.897	14.242	15.676	17.200	18.817	20.531	22.344	24.258	26.276	28.400	30.634	32.979	35.438	38.014	40.710	43.527	46.469	49.538	52.736	56.066	59.531	63.133	66.874	70.757
#	madurez	a	la	talla
0.006827132	0.009285246	0.012617161	0.017124033	0.023202938	0.031370932	0.042289772	0.056786181	0.07585818	0.100652094	0.132388874	0.172216392	0.220973892	0.278884822	0.345246539	0.418240623	0.495000167	0.571996133	0.645656306	0.713000163	0.772063549	0.822006314	0.862948707	0.895668777	0.921289663	0.941032987	0.956060185	0.967390545	0.975872979	0.982189568	0.986874682	0.990339477	0.992896226	0.994779874	0.99616598	0.997185073	0.99793385	0.998483753	0.998887464	0.999183772	0.99940121	0.999560749	0.999677795
#	CONTROLES		
#___________________________________________________________					
#	CV's	estimacion	de	parametros
#No	Rt	k	q_cru	A50f	M
0.5	0.5	0.2	0.5	0.5	0.1
#dev_qcru	dev_qCPUE		
0.1	10.5
#_____________________________________________________		
#	nm	tallas
#	Flota	Cruceros	
20	20
#	Fases	de	estimación	capturabilidad
#_____________________________________________________		
#	(opt_qCrucero	<0	es	q=1)	capturabilidad	Crucero	
4
#	(opt_qCPUE)	capturabilidad	CPUE
5
#	Fases	estimación	(Selectividad)
#_____________________________________________________		
#	(opt_Sel1)	Fase	estimacion	patron	de	explotacion	promedio)
2
#	(opt_Sel3)	Fase	Selectividad	flota	2N	unica
-2		
#	(opt_Sel4)	Fase	Selectividad	cruceros
4		
#	(opt_Sel5)	Sin	Selectividad	cruceros	(si	es	>0)
-1		
#_____________________________________________________		
#Parámetros	biológicos	
#	Loo	k	Lo	M    h
52	0.22	18	0.35 0.7  
#_________________________________			
#	Fases	estimación	de	parámetros	de	crecimiento
#	(opt_VB1)	fase	de	estimacion	de	Lo	(es	la	primera	talla	modal)

-2		

#	(opt_VB2)	fase	de	estimacion	desviacion	proporcional	con	la	talla	(cv_edad)

-3 

#	(opt_VB3)	fase	de	estimacion	de	desviacion	constante	(sd_edad)

3 
#	(opt_VB4)	fase	de	estimacion	de	desviacion	independiente	con	la	talla

-2 																							
#	(opt_VB5)	fase	de	estimacion	de	k

3 

#	opciones	de	estimación	de	parámetros	poblacionales
#	(opt_Rmed)	fase	de	estimación	de	Rmed

1 

#	(opt_devR)	fase	estimacion

1 

#	(opt_devNo)	Fase	estimacion	desvios	de	No	(<0	en	equilibrio)

1																							
#	(opt_F)	Fase	de	estimacion	de	F

2

#	(opt_M)	fase	de	estimacion	de	M

-3

#_____________________________________________________
#	Opciones	de	proyección
#	Estimador a 1 año
1																							
#	npbr: numero de estrategias (no incluye F=0)
4
#Objetivo de reducccion
0.4

#Fobj=F45

0.473768

################# EOF###################