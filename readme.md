# Harvest control rules for Chilean crustacean fisheries

The demersal crustacean fisheries in Chile, targeting nylon shrimp (_Heterocarpus reedi_), red squat lobster (_Grimothea monodon_), and yellow squat lobster (_Grimothea johni_) represent five single-species fishery units, and the management objective is to achieve the maximum sustainable yield (MSY).

The management challenge is to set simple, interpretable, robust, and precautionary harvest control rules (HCRs) to determine the primary management metric, i.e., an acceptable biological catch (ABC). The precautionary elements for a resilient HCR must consider a buffer for the target reference point, status-dependent thresholds and limits, and either model-based or data-based approaches. This project aims to evaluate the current management strategies for all certified fishery units of demersal crustaceans in Chile by using a Management Strategy Evaluation (MSE) framework. 

This repository is part of the activities of the MSC-OSF grant, entitled: “Evaluation of resilient harvest control rules for sustainable management of the Chilean demersal crustacean fisheries”, led by Dr. Luis A. Cubillos, [COPAS Coastal](https://copas-coastal.cl/), [Department of Oceanography](http://oceanografia.udec.cl), [University of Concepción, Concepción, Chile](https://www.udec.cl/pexterno/):

## Team

* María José Cuevas: Coding, assessment, and analysis of results.

* Ricardo Norambuena: Communications.

* Andrés Cubillos: Administration.

* Luis A. Cubillos: Project manager, conceptualization, evaluation of management strategies, coding, performance evaluation, and analysis of results.

## Meetings

- **27-03-2025: Comité de Manejo**, Tema: Reporte  Distribución de la biomasa de crustáceos demersales en la Unidad de Pesquería Sur.

- **20-05-2025:	Certificación MSC**, Tema: Auditoria seguimiento certificación MSC - Coordina: Bureau Veritas                 

- **04-06-2025: Comité Científico-Técnico**, Tema: Reunión Crustáceos Demersales	Segunda sesión de CCT-CD: presentación Proyecto MSC-OSF      

- **26-06-2025:	Comité de Manejo**, Presentación Proyecto MSC OSF para evaluar estrategias de gestión sostenible en pesquerías de crustáceos demersales 

- **11-07-2025:	Presidente Comité de Manejo**, Tema:	Revisión de reglas de control de captura de crustáceos demersales.

- **14-07-2025: CrustaSur SpA**, Tema: Plan de Acción  MSC Crustáceos Demersales 

- **30-09-2025:	Presidente Comité de Manejo**, Tema: Consulta por revisión y precisiones HCR - SUBPESCA

- **08-10-2025:	Presidente Comité de Manejo**, Tema: Reunión sobre Reglas de Control de Captura - SUBPESCA 

- **14/15-01-2026:	Taller de trabajo**,	Tema: Revisión por pares de la evaluación de camarón nailon, proyecto FIPA 2025-11, Viña del Mar, Chile.


## Reports

- Novemeber 2025:

[Cubillos, L.A., Cuevas, M.J. 2025. Revisión y precisiones de la regla de control de captura actual
para el manejo de crustáceos demersales.](https://github.com/LuisACubillos/Crustmod/blob/main/meetings/Reun2025-10-08_RRC/Revisión-precisionesRCC-crustáceos_demersales.pdf)

- January 2026:

[Cuevas, Ma.J., Cubillos L.A., 2026. Modelo de evaluación de stock estructurado por edad con heterogeneidad espacial para la pesquería de camarón nailon en Chile (Acción 1, Proyecto OSF-MSC). Universidad de Concepción, Informe Técnico EPOMAR 2026-01, 30 p.](https://github.com/LuisACubillos/Crustmod/blob/main/docs/Informe_Avance_ModeloCamarón_MSC-OSF-UdeC.pdf)

- March 2026:

[Cubillos L.A., Cuevas, Ma.J., 2026. Evaluación de reglas de control resilientes para el manejo sustentable de las pesquerías de crustáceos demersales chilenas (Acción 1-4, Proyecto OSF-MSC). Universidad de Concepción, Informe Técnico EPOMAR 2026-03, 37 p.](https://github.com/LuisACubillos/Crustmod/blob/main/docs/InfTec_ProyectoMSC-OSF_año1.pdf)


## Empirical harvest control rules

[Generic empirical harvest control rules for demersal crustacean fisheries](https://github.com/LuisACubillos/Crustmod/blob/main/docs/hcr_demersal_crustacean_fisheries.png)

## Technical issues

Codes are writen in [ADMB](http://www.admb-project.org/) ([Fournier et al. 2012](https://doi.org/10.1080/10556788.2011.597854)), alojados en carpetas para cada una de las pesquerías y contienen genéricamente:

SAM: Stock assessment models.

op1, op2, op3, ...: Operating models with different structural configurations

### Requerimientos

* A C++ compiler
* ADMB-12.0 or upper version
* R 4.4.1 or upper version

### Clone

	cd ~
	git clone https://github.com/luisacubillos/Crustmod
	cd Crustmod


