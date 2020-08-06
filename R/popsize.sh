#!/bin/bash

echo ""
echo "Run UK.R with populations of different sizes."
echo ""

for EXPON in -4 -3 -2 -1 0 1 2 3 4 5 6 7 8
do
	echo "Population Size * 2 ^ $EXPON."
	echo ""
	cp ./covidm/data/structure_$EXPON.rds ./covidm/data/structure_UK.rds
	cp ./covidm/data/wpp2019_pop2020_$EXPON.rds ./covidm/data/wpp2019_pop2020.rds
	Rscript UK.R 1 10
	rm ./covidm/data/structure_UK.rds
	rm ./covidm/data/wpp2019_pop2020.rds
	mv ./1-dynamics.qs ./1-dynamics_$EXPON.qs
	mv ./1-totals.qs ./1-totals_$EXPON.qs
	echo ""
done

echo "popsize.sh is DONE!"
