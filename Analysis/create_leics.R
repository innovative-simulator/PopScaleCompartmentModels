# Creates modified versions of the two input data files used by UK.R
# 

library(data.table)

# Edit the path below to point to your clone of LSHTM git folder.
covid_uk_path = "~/mygit/cmmid/covid-UK/"

# I've made copies of the original rds files, in case something goes wrong.
cm_structure_UK = readRDS(paste0(covid_uk_path, "covidm/data/original_structure_UK.rds"));
cm_populations = readRDS(paste0(covid_uk_path, "covidm/data/original_wpp2019_pop2020.rds"));

# Using Leicestershire as our single county.
X = cm_structure_UK[Name=="Leicestershire"];
#P = cm_populations[name=="UK | Leicestershire"]; # Not required. Modifying structure_UK is sufficient to determine your selection.
P = cm_populations;

for (b in c(-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8)) {
	a = 2.0 ^ b; # Rescalar.
	Y = X;
	Y[, 4:95] = round(X[,4:95] * a, 0); # Rescaling by age group.
	Q = P[,list(country_code,name, age, f=(f * a), m=(m * a), location_type)]; # Note not rounded.
	
	# Save new versions of data files. In popsize.sh Each pair will be renamed and then UK.R will be run with them.
	saveRDS(Y, paste0(covid_uk_path, "covidm/data/structure_", b, ".rds"))
	saveRDS(Q, paste0(covid_uk_path, "covidm/data/wpp2019_pop2020_", b,".rds"))
}
