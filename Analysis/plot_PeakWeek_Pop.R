### Analyze the dynamics from UK.R for different population sizes. ###

library(qs)
library(data.table)

library(ggplot2) # Data visualization library
library(extrafont) # More visually appealing fonts for figures

## Uncomment and run this command ONCE to ensure that your R build has
## required fonts available (no need to repeat on each run of the script).

# font_import()

# ^ run this once ^

# Run this command to ensure relevant fonts are available in the session.
loadfonts(device = "win")



# Edit to point to your working directory. Remember to convert \ to / or \\.
setwd("~/mygit/PopScaleCompartmentModels/Analysis")
setwd("D:\\MyDocus\\Simulation\\NetLogo\\Diffusion\\DiseaseDecisions\\git\\PopScaleCompartmentModels\\Analysis")

D <- qread("D_2_28.qs");
D <- cbind(D, seed_inf="2 for 28");
D_2_14 <- qread("D_2_14.qs");
D_2_14 <- cbind(D_2_14, seed_inf="2 for 14");
D_1_28 <- qread("D_1_28.qs");
D_1_28 <- cbind(D_1_28, seed_inf="1 for 28");
D <- rbind(D, D_2_14);
D <- rbind(D, D_1_28);

D_2_14 <- NULL
D_1_28 <- NULL


dim(D)
head(D)
D <- cbind(D, week = floor(D[,t] / 7));
head(D)
tail(D)

unique(D[,compartment])


# Weekly data

W <- D %>%
  filter(compartment=="cases" & region=="England") %>% # Select data subset
  group_by(pop_scale,
           scenario,
           run,
           compartment,
           region,
           seed_inf,
           week
           ) %>% # Aggregate over unique combinations of these variables
  summarise(
    total = sum(value) # For each group, provide the sum of value
  )

#qsave(W, veripath("W.qs"))

# Cases peak week

MW <- W %>%
  group_by(pop_scale,
           scenario,
           run,
           region,
           seed_inf) %>%
  summarise(
    max_week =  week[which.max(total)]
  )

#qsave(MW, veripath("MW.qs"))

N <- D %>%
  filter(compartment=="S", region=="England", t==0) %>%
  select(pop_scale,
         scenario,
         run,
         region,
         seed_inf,
         pop=value)


#qsave(N, veripath("N.qs"))

Y <- inner_join(N, MW) %>%
  filter(scenario=="Base") %>%
  group_by(pop, seed_inf) %>%
  summarise(
    peak_week = mean(max_week)
  )

#qsave(Y, veripath("Y.qs"))


## Colour version

p1 <- ggplot(Y,
             aes(x = log10(pop), # X axis variable, after log transform
                 y = peak_week,  # Y axis variable
                 group = seed_inf)) + # Grouping variable
          geom_point( # Display x,y pairs as points
            aes(shape=seed_inf, color=seed_inf) # Map the group variable to color and shape
            ) +
          xlim(4,9) + # Limits of the x axis
          ylim(9, 22) +
          scale_y_continuous(breaks=c(10,12,14,16,18,20,22)) +
          labs(y="Peak week",
               shape="Seed infections",
               color="Seed infections"
               ) + 
          xlab(bquote(log[10]~"of population size")) +
          theme_classic() + # Tidy up to formatting
          theme(legend.position="bottom", # Set text attributes, and legend position
                legend.text=element_text(size=8, family="Arial", color="black"),
                text=element_text(size=10, family="Arial"),
                axis.text = element_text(size=8, family="Arial", color="black")
                )
  
ggsave( # Save the plot object to file, with specified parameters. 
    filename = "LSHTM_peak_week_by_log_pop.tif",
    plot = p1,
    device = "tiff",
    width = 5.25,
    height = 5.25,
    units = "in",
    dpi = 300
  )

## BW version

p2 <- ggplot(Y,
             aes(x = log10(pop), # X axis variable, after log transform
                 y = peak_week,  # Y axis variable
                 group = seed_inf)) + # Grouping variable
          geom_point( # Display x,y pairs as points
            aes(shape=seed_inf) # Map the group variable to color and shape
            ) +
          xlim(4,9) + # Limits of the x axis
          ylim(9, 22) +
          scale_y_continuous(breaks=c(10,12,14,16,18,20,22)) +
          labs(y="Peak week",
               shape="Seed infections",
               color="Seed infections"
               ) + 
          xlab(bquote(log[10]~"of population size")) +
          theme_classic() + # Tidy up to formatting
          theme(legend.position="bottom", # Set text attributes, and legend position
                legend.text=element_text(size=8, family="Arial", color="black"),
                text=element_text(size=10, family="Arial"),
                axis.text = element_text(size=8, family="Arial", color="black")
                )

ggsave( # Save the plot object to file, with specified parameters. 
    filename = "LSHTM_peak_week_by_log_pop_MONO.tif",
    plot = p2,
    device = "tiff",
    width = 5.25,
    height = 5.25,
    units = "in",
    dpi = 300
  )

## Regression Analysis

lmod_2_28 = lm(peak_week ~ log_pop, data=as.data.table(Y)[seed_inf=="2 for 28",list(log_pop=log10(pop), peak_week)])
summary(lmod_2_28)


# This estimates regression parameters for the slope by group, and returns a dataframe.
regression_results_df <- Y %>%
  mutate(log_pop = log10(pop)) %>%
  group_by(seed_inf) %>%
  group_modify(~ broom::tidy(lm(peak_week ~ log_pop, data=.x)))

write.csv(regression_results_df, file = "lin_model_results.csv")

