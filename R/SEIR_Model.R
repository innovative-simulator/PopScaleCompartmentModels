# SEIR Model of Disease Transmission

library(deSolve)
library(data.table)

# Compartmental model defined by function

SEIR <- function(t, state, parameters) {
	with(as.list(c(state, parameters)), {
		dS <- -beta * u * S * I / (S + E + I + R)
		dE <- -dS - E * alpha
		dI <- E * alpha - I * gamma
		dR <- I * gamma
		list(c(dS, dE, dI, dR))
	})
}

# Set up model

delta_t = 0.25
state      <- c(S=66000000, E=1, I=0, R=0)
times      <- seq(0, 365, by = 0.25)
parameters <- c(beta = 8.0 * delta_t, alpha = (1.0 / 1.0) * delta_t, gamma = (1.0 / 8.0) * delta_t, u = 0.08)

# Test output

out <- ode(y = state, times = times, func = SEIR, parms = parameters)
plot(out)

head(out)
peak_week <- out[which.max(out[,"I"])] / 7
peak_week

# Try various population sizes

Y <- data.table(pop_size = integer(), seeding=character(), peak_week = double())
for (j in 1:2) {
	for (i in 1:13) {
		N <- 700000 * (2 ^ (i - 5))
		state      <- c(S=N - j, E=j, I=0, R=0)
		out <- ode(y = state, times = times, func = SEIR, parms = parameters)
		Y <- rbind(Y, data.table(pop_size=N, seeding=j, peak_week = out[which.max(out[,"I"])] / 7))
	}
}

head(Y)

# See for time to peak infections its sensitivity 
# to population size and number of seed infections.

dev.off()
plot(Y[seeding==1,list(log_pop=log10(pop_size), peak_week)], type="p", xlim=c(4, 9), ylim=c(min(Y[seeding==2,peak_week]), max(Y[seeding==1,peak_week])), pch=1, col="blue", xlab="Log10 of Population", ylab="Peak Week")
lines(Y[seeding==2,list(log_pop=log10(pop_size), peak_week)], type="p", pch=3, col="red")
legend("bottomright", legend=c("Seeds = 1", "Seeds = 2"), pch=c(1,3), col=c("blue", "red"), inset = c(0.1, 0.1));

lmod1 = lm(peak_week ~ log_pop, data=Y[seeding==1,list(log_pop=log10(pop_size), peak_week)])
summary(lmod1)

