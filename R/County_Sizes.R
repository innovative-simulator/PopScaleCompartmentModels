# Produce a histogram of population size for UK county-level administrative units.

library(data.table)

# Change this:
setwd("~/mygit/cmmid/covid-UK/covidm/data/")

U <- readRDS("structure_UK.rds")
dim(U)
head(U)
tail(U)
unique(U[,Geography1])

# These are the labels for the various UK county-level administrative units.
cn <- c("Unitary Authority", "Metropolitan County", "County", "London Borough", "Local Government District", "Council Area")
C <- U[Geography1 %in% cn]
C <- C[,list(Geography1, Name, All_ages=C$"All ages")]


dim(C)
unique(C[,Geography1])

# Check we got them all.
table(U[,Geography1])
table(C[,Geography1])
32 + 26 + 11 + 33 + 6 + 78 # Should be 186

head(setorder(C, All_ages)) # Smallest
head(setorder(C, -All_ages)) # Biggest

# Histograms
hist(C[,All_ages])
hist(C[,log10(All_ages)]) # Log normal, plus outliers in lower tail.?

# Other useful statistics
median(C[,All_ages])
mean(C[,All_ages])
10 ^ mean(C[,log10(All_ages)])

