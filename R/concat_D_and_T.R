### Concatenating UK.R output files ###

library(qs)
library(data.table)

# Check the working directory. Remember to convert \ to / or \\.
setwd("~/mygit/cmmid/covid-UK")

X <- qread("1-dynamics_-4.qs");
D <- cbind(pop_scale = -4, X);
Y <- qread("1-totals_-4.qs");
T <- cbind(pop_scale = -4, Y);

for (scale_name in c(-3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8))
{
	scale_name
	X <- qread(paste0("1-dynamics_", scale_name, ".qs"));
	D <- rbind(D, cbind(pop_scale = scale_name, X));
	Y <- qread(paste0("1-totals_", scale_name, ".qs"));
	T <- rbind(T, cbind(pop_scale = scale_name, Y));
}

head(D)
dim(D)
unique(D[,1]) # pop_scale
unique(D[,2]) # scenario
dim(unique(D[,3])) # run
dim(unique(D[,4])) # t
unique(D[,5]) # compartment

head(T)
dim(T)
unique(T[,1]) # pop_scale
unique(T[,2]) # scenario
dim(unique(T[,3])) # run
unique(T[,4]) # compartment
unique(T[,5]) # group

qsave(D, "D.qs");
qsave(T, "T.qs");
