# MSE Chilean crustacean fisheries

Management Strategy Evaluation (MSE) for demersal crustacean fisheries in Chile:

a) yellow squat lobster (_Grimothea johni_),

b) red squat lobster (_Grimothea monodon_),

c) nylon shrimp (_Heterocarpus reedi_). 

This activity is part of the results of the MSC-OSF grant, entitled: “Evaluation of resilient harvest control rules for sustainable management of the Chilean demersal crustacean fisheries”, led by Dr. Luis A. Cubillos, [COPAS Coastal](https://copas-coastal.cl/), [Department of Oceanography](http://oceanografia.udec.cl), [University of Concepción, Concepción, Chile](https://www.udec.cl/pexterno/):

 * María José Cuevas: Coding, assessment, and analysis of results.

* Ricardo Norambuena: Communications.

* Andrés Cubillos: Administration.

 * Luis A. Cubillos: Project manager, conceptualization, evaluation of management strategies, coding, performance evaluation, and analysis of results.

## Technical issues

Codes are writen in [ADMB](http://www.admb-project.org/) ([Fournier et al. 2012](https://doi.org/10.1080/10556788.2011.597854)), alojados en carpetas para cada una de las pesquerías y contienen genéricamente:

Est1: Modelo de evaluación de stock o estimador.

MO1, MO2, MO3, and MO4: Operative models with different structural configurations

### Requerimientos

* Un compilador C++
* ADMB-12.0 o superior
* R 4.4.1 o superior; y RStudio

### Clone

	cd ~
	git clone https://github.com/luisacubillos/01MSECRUSTDEM
	cd 01MSECRUSTDEM

