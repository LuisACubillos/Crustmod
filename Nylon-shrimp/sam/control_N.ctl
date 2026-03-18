
##Controles
#	madurez	a	la	talla	Fincional	(Flores,	2020)																												
0.00001	0.00003	0.00007	0.00014	0.00031	0.00068	0.00148	0.00321	0.00698	0.01508	0.0323	0.0678	0.13681	0.25674	0.42947	0.62128	0.78143	0.88625	0.94438	0.97369	0.98775	0.99434	0.9974	0.9988	0.99945	0.99975	0.99988	0.99995	0.99998	0.99999	0.99999	1	1	1	1	1
# Langostino colorado UP norte																
# Coeficientes de variación cuando estima ciertos parametros																
#No	Rt	k	q_cru	A50f	M	dev_qcru	dev_qCPUE									
0.5	0.5	0.1	0.5	0.5	0.1	0.1	        10.5									
#___________________________________________________________																
# (nmus) Tamaños de muestra composición de tallas																
# Flota	Cruceros															
20   20															
#_____________________________________________________																
# Fases de estimación de capturabilidad																
# (opt_qCruce<0 es q= 1)  Capturabilidad crucero																
-1
# Años y Fase con cambios en qCrucero (si > 0)																
#1961	1962	1963	1964	1965	1966	1967	1968	1969	1970	1971	1972	1973	1974	1975	1976	1977	1978	1979	1980	1981	1982	1983	1984	1985	1986	1987	1988	1989	1990	1991	1992	1993	1994	1995	1996	1997	1998	1999	2000	2001	2002	2003	2004	2005	2006	2007	2008	2009	2010	2011	2012	2013	2014	2015	2016	2017	2018	2019	2020	2021	2022	2023	2024
# Base sin cambios 																
#-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1    -1   -1   
# Base con cambios en 2004																
-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	5	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1				
#  (opt_qCPUE ) capturabilidad CPUE 																
3
# Años y fase con cambios en qCPUE (si >0)																
#1961	1962	1963	1964	1965	1966	1967	1968	1969	1970	1971	1972	1973	1974	1975	1976	1977	1978	1979	1980	1981	1982	1983	1984	1985	1986	1987	1988	1989	1990	1991	1992	1993	1994	1995	1996	1997	1998	1999	2000	2001	2002	2003	2004	2005	2006	2007	2008	2009	2010	2011	2012	2013	2014	2015	2016	2017	2018	2019	2020	2021
-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1																
#_____________________________________________________																
# Fases estimación (de selectividad)																
# (opt_Sel1) Fase estimación patrón de explotación promedio																
2
# (opt_Sel2) Fase desvios en la selectividad de la flota (variable si >0)																
#1961	1962	1963	1964	1965	1966	1967	1968	1969	1970	1971	1972	1973	1974	1975	1976	1977	1978	1979	1980	1981	1982	1983	1984	1985	1986	1987	1988	1989	1990	1991	1992	1993	1994	1995	1996	1997	1998	1999	2000	2001	2002	2003	2004	2005	2006	2007	2008	2009	2010	2011	2012	2013	2014	2015	2016	2017	2018	2019	2020	2021
#-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1    -1     -1
# sin cambios en selectividad																
-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1	-1															
# (opt_Sel3) Fase Selectividad flota 2N unica																
-2																
# (opt_Sel4) Fase Selectividad cruceros																
4																
# (opt_Sel5) Sin selectividad cruceros (si es >0)																
-1																
#_____________________________________________________																
#	Parámetros	biológicos
#Estimados por canales et al. (2016)
#  Loo	k	Lo	M		h											
41.1	0.14	15	0.36	0.7													
#_____________________________________________________																
# Fases estimación de parámetros de crecimiento																
# (opt_VB1) fase de estimacón de Lo (es la primera talla modal)																
2																
# (opt_VB2 fase de estimación desviación proporcional con la talla (cv_edad) 																
3																
# (opt_VB3) fase de estimación de desviación constante (sd_edad)																
-2																
# (opt_VB4) fase de estimación de desviación independiente con la talla																
-2																
# (opt_VB5) fase de estimación de k																
-3																
#_____________________________________________________																
# Opciones de estimación de parámetros poblacionales																
# (opt_Rmed) fase de estimación de R med																
1																
# (opt_devR) fase de estimación de desvíos de R																
1																
# (opt_devNo) fase de estimación desvios No (<0 en equilibrio)																
1																
# (opt_F) fase de estimación de F																
1																
#  (opt_M)  fase de estimación de M																
-3																
#_____________________________________________________																
# Opciones de proyección																
# N años futuro																
10														
#  N pbr																
5																
# Proyección de capturas ante distintos niveles de Reclutamiento (1.0 proporcional al reclutamiento medio)
1
#F1            F30         F40        F45       Fsq												
7.23922e-006  0.550243    0.267908   0.227332   0.075

