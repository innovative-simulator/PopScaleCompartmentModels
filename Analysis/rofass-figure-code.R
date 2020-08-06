### How to use this file ###

### Install the following packages

library(qs) # I/O
library(dplyr) # Data Manipulation
library(fs) # Cross Platform file paths
library(purrr) # Vectorised alternatives to looping (map, etc.)
library(ggplot2) # Data visualization library
library(extrafont) # More visually appealing fonts for figures

## Uncomment and run this command ONCE to ensure that your R build has
## required fonts available (no need to repeat on each run of the script).

# font_import()

# ^ run this once ^

# Run this command to ensure relevant fonts are available in the session.
loadfonts(device = "win")

## This wrapper function will allow us to avoid using any kind of absolute
## path, or manipulation of the working directory. Just supply the file
## name in the PopSize folder. 
ppath <- function(file_name){
  return(fs::path("Experiments", "PopSize", file_name))
}
# As above, for saving intermediate outputs to the 'verification' subfolder
veripath <- function(file_name){
  return(fs::path("Experiments", "PopSize","verification", file_name))
}

# My understanding of this process, is that you are loading these separate
# data files, adding a column with seeding information, then combining them
# row wise. 
datasets <- c("D.qs", "D_2_14.qs", "D_1_28.qs")
seed_information <-  c("2 for 28", "2 for 14", "1 person per day for 28 days")
# This maps the data file names and seed information to a function which returns
# the data with seed information, then it combines the returned data frames
# rowwise (i.e. rbind).
d_combined_data <- purrr::map2_dfr(
  datasets,
  seed_information,
  function(data, seed_info) {
    qs::qread(ppath(data)) %>% dplyr::mutate(seed_inf=seed_info)
  }) %>%
  mutate( # Here we add the week column
    week = floor(t / 7)
  ) 

qsave(d_combined_data, veripath("D_LTD_version.qs"))


# Weekly data

W <- d_combined_data %>%
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

qsave(W, veripath("W_LTD_version.qs"))

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

qsave(MW, veripath("MW_LTD_version.qs"))

N <- d_combined_data %>%
  filter(compartment=="S", region=="England", t==0) %>%
  select(pop_scale,
         scenario,
         run,
         region,
         seed_inf,
         pop=value)


qsave(N, veripath("N_LTD_version.qs"))

Y <- inner_join(N, MW) %>%
  filter(scenario=="Base") %>%
  group_by(pop, seed_inf) %>%
  summarise(
    peak_week = mean(max_week)
  )

qsave(Y, veripath("Y_LTD_version.qs"))

## You can paste the below code into your original code 
## (make sure your also load the gpplot and extrafonts libraries above )

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
    filename = ppath("LSHTM_peak_week_by_log_pop.jpg"),
    plot = p1,
    device = "jpeg",
    width = 5.25,
    height = 5.25,
    units = "in",
    dpi = 800
  )

## Regression Analysis

# This estimates regression parameters for the slope by group, and returns a dataframe.
regression_results_df <- Y %>%
  mutate(log_pop = log10(pop)) %>%
  group_by(seed_inf) %>%
  group_modify(~ broom::tidy(lm(peak_week ~ log_pop, data=.x)))

write.csv(regression_results_df, file = ppath("lin_model_results.csv"))
