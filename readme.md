# Harvest control rules for Chilean crustacean fisheries

The demersal crustacean fisheries in Chile, targeting nylon shrimp (_Heterocarpus reedi_), red squat lobster (_Grimothea monodon_), and yellow squat lobster (_Grimothea johni_) represent five single-species fishery units, and the management objective is to achieve the maximum sustainable yield (MSY).

The management challenge is to set simple, interpretable, robust, and precautionary harvest control rules (HCRs) to determine the primary management metric, i.e., an acceptable biological catch (ABC). The precautionary elements for a resilient HCR must consider a buffer for the target reference point, status-dependent thresholds and limits, and either model-based or data-based approaches. This project aims to evaluate the current management strategies for all certified fishery units of demersal crustaceans in Chile by using a Management Strategy Evaluation (MSE) framework. 

This repository is part of the activities of the MSC-OSF grant, entitled: “Evaluation of resilient harvest control rules for sustainable management of the Chilean demersal crustacean fisheries”, led by Dr. Luis A. Cubillos, [COPAS Coastal](https://copas-coastal.cl/), [Department of Oceanography](http://oceanografia.udec.cl), [University of Concepción, Concepción, Chile](https://www.udec.cl/pexterno/):

## Team

* María José Cuevas: Coding, assessment, and analysis of results.

* Ricardo Norambuena: Communications.

* Andrés Cubillos: Administration.

 * Luis A. Cubillos: Project manager, conceptualization, evaluation of management strategies, coding, performance evaluation, and analysis of results.

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


