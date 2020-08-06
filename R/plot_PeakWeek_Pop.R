### Analyze the dynamics from UK.R for different population sizes. ###

library(qs)
library(data.table)

# Edit to point to your working directory. Remember to convert \ to / or \\.
setwd("~/mygit/cmmid/covid-UK")

D <- qread("D.qs");
D <- cbind(D, seed_inf="2 for 28");
D_2_14 <- qread("D_2_14.qs");
D_2_14 <- cbind(D_2_14, seed_inf="2 for 14");
D_1_28 <- qread("D_1_28.qs");
D_1_28 <- cbind(D_1_28, seed_inf="1 for 28");
D <- rbind(D, D_2_14);
D <- rbind(D, D_1_28);

dim(D)
head(D)
D <- cbind(D, week = floor(D[,t] / 7));
head(D)
tail(D)

# Aide memoire for data.table syntax:
# DT[i, j, by]
##   R:                 i                 j        by
## SQL:  where | order by   select | update  group by
# Take DT, subset/reorder rows using i, then calculate j, grouped by by.

unique(D[,compartment])

# SEI3R

plotdata1 = D[pop_scale == -4 & scenario=="Base" & region=="England" & seed_inf=="2 for 28" & run==1,list(t, compartment, value)];
n = max(plotdata1[,value]) / 100;
plot(c(0, 182), c(0, max(plotdata1[,value / n])), type = "n", xlab="Day", ylab="People") # Draw plot with scaled axes.
lines(plotdata1[compartment=="S" & t >= 0 & t <= 182,list(t, value / n)], type="l", col="green")
lines(plotdata1[compartment=="E" & t >= 0 & t <= 182,list(t, value / n)], type="l", col="light green")
lines(plotdata1[compartment=="Ip" & t >= 0 & t <= 182,list(t, value / n)], type="l", col="orange")
lines(plotdata1[compartment=="Is" & t >= 0 & t <= 182,list(t, value / n)], type="l", col="red")
lines(plotdata1[compartment=="Ia" & t >= 0 & t <= 182,list(t, value / n)], type="l", col="brown")
lines(plotdata1[compartment=="R" & t >= 0 & t <= 182,list(t, value / n)], type="l", col="blue")

# cases - Base All 10 runs

plotdata1 = D[pop_scale == -4 & scenario=="Base" & region=="England" & seed_inf=="2 for 28" & compartment=="cases",list(t, run, value)];
plot(c(0, 182), c(0, max(plotdata1[,value])), type = "n", xlab="Day", ylab="New Cases") # Draw plot with scaled axes.
lines(plotdata1[run==1 & t >= 0 & t <= 182,list(t, value)], type="l", col="red")
lines(plotdata1[run==2 & t >= 0 & t <= 182,list(t, value)], type="l", col="orange")
lines(plotdata1[run==3 & t >= 0 & t <= 182,list(t, value)], type="l", col="yellow")
lines(plotdata1[run==4 & t >= 0 & t <= 182,list(t, value)], type="l", col="light green")
lines(plotdata1[run==5 & t >= 0 & t <= 182,list(t, value)], type="l", col="green")
lines(plotdata1[run==6 & t >= 0 & t <= 182,list(t, value)], type="l", col="light blue")
lines(plotdata1[run==7 & t >= 0 & t <= 182,list(t, value)], type="l", col="dark blue")
lines(plotdata1[run==8 & t >= 0 & t <= 182,list(t, value)], type="l", col="purple")
lines(plotdata1[run==9 & t >= 0 & t <= 182,list(t, value)], type="l", col="violet")
lines(plotdata1[run==10 & t >= 0 & t <= 182,list(t, value)], type="l", col="pink")

unique(D[,scenario])

# cases - Combination All 10 runs

plotdata1 = D[pop_scale == -4 & scenario=="Combination" & region=="England" & seed_inf=="2 for 28" & compartment=="cases",list(t, run, value)];
plot(c(0, 182), c(0, max(plotdata1[,value])), type = "n", xlab="Day", ylab="New Cases") # Draw plot with scaled axes.
lines(plotdata1[run==1 & t >= 0 & t <= 182,list(t, value)], type="l", col="red")
lines(plotdata1[run==2 & t >= 0 & t <= 182,list(t, value)], type="l", col="orange")
lines(plotdata1[run==3 & t >= 0 & t <= 182,list(t, value)], type="l", col="yellow")
lines(plotdata1[run==4 & t >= 0 & t <= 182,list(t, value)], type="l", col="light green")
lines(plotdata1[run==5 & t >= 0 & t <= 182,list(t, value)], type="l", col="green")
lines(plotdata1[run==6 & t >= 0 & t <= 182,list(t, value)], type="l", col="light blue")
lines(plotdata1[run==7 & t >= 0 & t <= 182,list(t, value)], type="l", col="dark blue")
lines(plotdata1[run==8 & t >= 0 & t <= 182,list(t, value)], type="l", col="purple")
lines(plotdata1[run==9 & t >= 0 & t <= 182,list(t, value)], type="l", col="violet")
lines(plotdata1[run==10 & t >= 0 & t <= 182,list(t, value)], type="l", col="pink")

# death_o All 10 runs

plotdata1 = D[pop_scale == -4 & scenario=="Base" & region=="England" & seed_inf=="2 for 28" & compartment=="death_o",list(t, run, value)];
plot(c(0, 182), c(0, max(plotdata1[,value])), type = "n", xlab="Day", ylab="New Deaths") # Draw plot with scaled axes.
lines(plotdata1[run==1 & t >= 0 & t <= 182,list(t, value)], type="l", col="red")
lines(plotdata1[run==2 & t >= 0 & t <= 182,list(t, value)], type="l", col="orange")
lines(plotdata1[run==3 & t >= 0 & t <= 182,list(t, value)], type="l", col="yellow")
lines(plotdata1[run==4 & t >= 0 & t <= 182,list(t, value)], type="l", col="light green")
lines(plotdata1[run==5 & t >= 0 & t <= 182,list(t, value)], type="l", col="green")
lines(plotdata1[run==6 & t >= 0 & t <= 182,list(t, value)], type="l", col="light blue")
lines(plotdata1[run==7 & t >= 0 & t <= 182,list(t, value)], type="l", col="dark blue")
lines(plotdata1[run==8 & t >= 0 & t <= 182,list(t, value)], type="l", col="purple")
lines(plotdata1[run==9 & t >= 0 & t <= 182,list(t, value)], type="l", col="violet")
lines(plotdata1[run==10 & t >= 0 & t <= 182,list(t, value)], type="l", col="pink")

# icu_p All 10 runs

plotdata1 = D[pop_scale == 3 & scenario=="Base" & region=="England" & seed_inf=="2 for 28" & compartment=="icu_p",list(t, run, value)];
plot(c(0, 182), c(0, max(plotdata1[,value])), type = "n", xlab="Day", ylab="ICU") # Draw plot with scaled axes.
lines(plotdata1[run==1 & t >= 0 & t <= 182,list(t, value)], type="l", col="red")
lines(plotdata1[run==2 & t >= 0 & t <= 182,list(t, value)], type="l", col="orange")
lines(plotdata1[run==3 & t >= 0 & t <= 182,list(t, value)], type="l", col="yellow")
lines(plotdata1[run==4 & t >= 0 & t <= 182,list(t, value)], type="l", col="light green")
lines(plotdata1[run==5 & t >= 0 & t <= 182,list(t, value)], type="l", col="green")
lines(plotdata1[run==6 & t >= 0 & t <= 182,list(t, value)], type="l", col="light blue")
lines(plotdata1[run==7 & t >= 0 & t <= 182,list(t, value)], type="l", col="dark blue")
lines(plotdata1[run==8 & t >= 0 & t <= 182,list(t, value)], type="l", col="purple")
lines(plotdata1[run==9 & t >= 0 & t <= 182,list(t, value)], type="l", col="violet")
lines(plotdata1[run==10 & t >= 0 & t <= 182,list(t, value)], type="l", col="pink")


# Population sizes (This is one way to do this - but see later for another)

N <-  D[compartment=="S" & region=="England" & t == 0 , list(pop_scale, scenario, run, region, seed_inf, pop=value), by=list()];
unique(N[,pop])
head(N)
dim(N)

# Weekly data

W <- D[compartment=="cases" & region=="England", list(total=sum(value)), by=list(pop_scale, scenario, run, compartment, region, seed_inf, week)];
dim(W)
head(W)
tail(W)

# Cases peak week (This our chart for the RofASSS paper!)

MW <- W[, list(max_week=which.max(total)), by=list(pop_scale, scenario, run, region, seed_inf)];
NMW <- cbind(N[,list(pop_scale, scenario, run, pop, seed_inf)], max_week=MW[, max_week])
Y <- NMW[scenario=="Base", list(peak_week=mean(max_week)), list(pop, seed_inf)];

plot(c(4,9),c(10,22), type="n", xlab="Log10 Population", ylab="Peak Week")
lines(Y[seed_inf=="2 for 28",list(log_pop=log10(pop), peak_week)], type="p", pch=1, col="blue")
lines(Y[seed_inf=="2 for 14",list(log_pop=log10(pop), peak_week)], type="p", pch=3, col="darkgreen")
lines(Y[seed_inf=="1 for 28",list(log_pop=log10(pop), peak_week)], type="p", pch=2, col="red")
legend("bottomright", legend=c("2 for 28", "2 for 14", "1 for 28" ), pch=c(1,3,2), col=c("blue", "darkgreen", "red"), inset = c(0.1, 0.1));

lmod_2_28 = lm(peak_week ~ log_pop, data=Y[seed_inf=="2 for 28",list(log_pop=log10(pop), peak_week)])
summary(lmod_2_28)
lmod_2_14 = lm(peak_week ~ log_pop, data=Y[seed_inf=="2 for 14",list(log_pop=log10(pop), peak_week)])
summary(lmod_2_14)
lmod_1_28 = lm(peak_week ~ log_pop, data=Y[seed_inf=="1 for 28",list(log_pop=log10(pop), peak_week)])
summary(lmod_1_28)

log10(66000000) * 2.70135 - 1.79772
log10(355000) * 2.70135 - 1.79772
log10(40000) * 2.70135 - 1.79772
log10(1560000) * 2.70135 - 1.79772
log10(700000) * 2.70135 - 1.79772






# Peak week cases

M <- W[, list(max_cases=max(total)), by=list(pop_scale, scenario, run, region, seed_inf)];
NM <- cbind(N[,list(pop_scale, scenario, run, pop, seed_inf)], max_cases=M[, max_cases]);
Z <- NM[scenario=="Base", list(peak_cases=mean(max_cases) / pop), list(pop, seed_inf)];

plot(c(4,9), c(0,100), type="p", xlab="Log10 Population", ylab="Peak Cases as % Pop", ylim=c(0, 100));
lines(Z[seed_inf=="2 for 28",list(log_pop=log10(pop), 100 * peak_cases)], type="p", pch=1, col="blue")
lines(Z[seed_inf=="2 for 14",list(log_pop=log10(pop), 100 * peak_cases)], type="p", pch=3, col="darkgreen")
lines(Z[seed_inf=="1 for 28",list(log_pop=log10(pop), 100 * peak_cases)], type="p", pch=2, col="red")
legend("topright", legend=c("2 for 28", "2 for 14", "1 for 28" ), pch=c(1,3,2), col=c("blue", "darkgreen", "red"), inset = c(0.1, 0.1));

tail(Z[,list(log_pop=log10(pop), peak_cases_perc=100 * peak_cases, seed_inf)])

# Peak new deaths

WD <- D[compartment=="death_o" & region=="England", list(total=sum(value)), by=list(pop_scale, scenario, run, compartment, region, seed_inf, week)];
M <- WD[, list(max_deaths=max(total)), by=list(pop_scale, scenario, run, region, seed_inf)];
NM <- cbind(N[,list(pop_scale, scenario, run, pop, seed_inf)], max_deaths=M[, max_deaths]);
Z <- NM[scenario=="Base", list(peak_deaths=mean(max_deaths) / pop), list(pop, seed_inf)];

plot(Z[seed_inf=="2 for 28",list(log_pop=log10(pop), 100 * peak_deaths)], type="p", xlab="Log10 Population", ylab="Peak Deaths as % Pop", ylim=c(0, 1))
tail(Z[seed_inf=="2 for 28",list(log_pop=log10(pop), 100 * peak_deaths)])


# ICU beds > threshold

# SEI3R <- with compartment=="S" or E or I...
D_SEIR <- D[compartment=="S" | compartment=="E" | compartment=="Ip" | compartment=="Is" | compartment=="Ia" | compartment=="R"];
unique(D[,compartment])
dim(D)
dim(D_SEIR)
dim(D_SEIR)[1] / 6
unique(D_SEIR[,compartment])
DN <- D_SEIR[, list(N=sum(value)), by=list(pop_scale, scenario, run, region, seed_inf, t, week)];
dim(DN)
dim(D[compartment=="icu_p"])
D_ICU_N <- cbind(D[compartment=="icu_p"], DN)[,list(value, pop_scale=DN$pop_scale, scenario=DN$scenario, run=DN$run, region=DN$region, seed_inf=DN$seed_inf, t=DN$t, week=DN$week, N)];
dim(D_ICU_N)
head(D_ICU_N)

# 5000 icu beds for 66 million people
# (Of course, any intervention should be triggered before you hit crisis,
# because it takes several days for infected people to reach ICU.)
D_crisis <- D_ICU_N[(value / N) > (5000 / 66000000),list(crisis_start=min(t),crisis_end=max(t)),list(pop_scale,scenario,run,region,seed_inf,N)];
head(D_crisis)
unique(D_crisis[scenario=="Base" & region=="England" & seed_inf=="2 for 28",run])
D_crisis[scenario=="Base" & region=="England" & seed_inf=="2 for 28" & run==1]

Yc <- D_crisis[scenario=="Base" & region=="England", list(crisis_start=mean(crisis_start), crisis_end=mean(crisis_end)),list(pop_scale, seed_inf, N)];
head(Yc)
dim(Yc)
unique(Yc[,N])

plot(c(4,9),c(0,26), type="n", xlab="Log10 Population", ylab="Crisis Week")
lines(Yc[seed_inf=="2 for 28",list(log_pop=log10(N), crisis_start / 7)], type="p", pch=1, col="blue")
lines(Yc[seed_inf=="2 for 14",list(log_pop=log10(N), crisis_start / 7)], type="p", pch=3, col="darkgreen")
lines(Yc[seed_inf=="1 for 28",list(log_pop=log10(N), crisis_start / 7)], type="p", pch=2, col="red")
legend("bottomright", legend=c("2 for 28", "2 for 14", "1 for 28" ), pch=c(1,3,2), col=c("blue", "darkgreen", "red"), inset = c(0.1, 0.1));


plot(Yc[seed_inf=="2 for 28",list(log_pop=log10(N), crisis_end / 7)], type="p", xlab="Log10 Population", ylab="Crisis End Week")
plot(Yc[seed_inf=="2 for 28",list(log_pop=log10(N), (crisis_end - crisis_start) / 7)], type="p", xlab="Log10 Population", ylab="Crisis Duration (Weeks)",ylim=c(0,26))

lmod1_2_28 = lm(crisis_start ~ log_pop, data=Yc[seed_inf=="2 for 28",list(log_pop=log10(N), crisis_start=(crisis_start / 7))])
summary(lmod1_2_28)
lmod1_2_14 = lm(crisis_start ~ log_pop, data=Yc[seed_inf=="2 for 14",list(log_pop=log10(N), crisis_start=(crisis_start / 7))])
summary(lmod1_2_14)
lmod1_1_28 = lm(crisis_start ~ log_pop, data=Yc[seed_inf=="1 for 28",list(log_pop=log10(N), crisis_start=(crisis_start / 7))])
summary(lmod1_1_28)




#
