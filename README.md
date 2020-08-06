# PopScaleCompartmentModels
R scripts and xlsx files for compartmental models of populations varying in scale.

These files were used in support of the paper:
Watts, Christopher, Chattoe-Brown, Edmund, Droy, Laurence, Gilbert, Nigel, Ladley, Daniel, Robertson, Duncan, (submitted to RofASSS) "The role of population scale  in compartmental models of Covid-19 transmission".

## xlsx for compartmental models

The xlsx folder contains Excel workbooks. They implement several types of compartmental model of disease transmission (SI, SIR, SEIR). As they illustrate, the times of occurrence of epidemic events such as peak cases are sensitive to the size of population and the number of initial seed infections.

## R scripts for data analysis

The R folder contains R scripts and one shell script. These were used to run the experiment described in the paper, and produce its chart, showing a linear trend between time to peak cases, and the base-10 logarithm of population size. 

### The LSHTM model

To use them, you first need to clone the git for the compartment model of COVID-19 transmission, produced by the London School of Hygiene & Tropical Medicine (LSHTM). This can be found at:

https://github.com/cmmid/covid-UK

Check you can use this by running:

Rscript UK.R 1 10

We cannot offer you help with getting the LSHTM model working. (A virtual machine running Debian worked for us.)

### Using our scripts

Our scripts work with the LSHTM model by modifying two of its input data files. From the base folder of your cmmid/covid-UK git clone (the one with UK.R), go to ./covidm/data and make backup copies:

cp structure_UK.rds original_structure_UK.rds
cp wpp2019_pop2020.rds original_wpp2019_pop2020.rds

Once you have got their model working, copy all the files in our R folder to the base folder of your cmmid/covid-UK clone. 

Some scripts may need editting to set the working directory correctly for your computer. The order in which you run them is:

* create_leics.R
* popsize.sh
* concat_D_and_T.R
* plot_PeakWeek_Pop.R

"create_leics.R" makes new versions of the input data files. structure_UK.rds is alterred to contain just one geographical area, the county of Leicestershire. wpp2019_pop2020.rds is editted to contain re-scaled population sizes. Used together, you can run the LSHTM model with re-scaled versions of one county.

"popsize.sh" is a Bash shell script. For each population scale, it brings in the corresponding input data files, runs UK.R, and then renames the two output data files ("1-dynamics.qs" and "1-totals.qs") to correspond with the population scale.

"concat_D_and_T.R" reads these output data files into R and row-binds them together to make one data file, adding a field for population scale.

"plot_PeakWeek_Pop.R" reads in the combined output data file, and then performs various analyses, including generating a version of the chart in our paper.

### Disclaimer

All materials are provided as is, and we make no guarantees of their working for you, or of their being suitable for your own purposes. You use them at your own risk.

Unless explicitly stated otherwise, all software posted here is made available under the GNU Public Licence, version 3.
