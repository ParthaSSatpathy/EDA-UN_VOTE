###Modelling####

# Percentage of yes votes from the US by year: US_by_year
US_by_year <- by_year_country %>%
  filter(country == "United States of America")

# Print the US_by_year data
US_by_year

# Perform a linear regression of percent_yes by year: US_fit
US_fit <- lm(percent_yes ~ year,US_by_year)

# Perform summary() on the US_fit object
summary(US_fit)

#############Tidying a lin regression model##########
##use the tidy() function in the broom package to turn that model into a tidy data frame.

# Load the broom package
library(broom)

# Call the tidy() function on the US_fit object
tidy(US_fit)

##One important advantage of changing models to tidied data frames is that they can be combined.

# Fit model for the United Kingdom
UK_by_year <- by_year_country %>%
  filter(country == "United Kingdom of Great Britain and Northern Ireland")
UK_fit <- lm(percent_yes ~ year, UK_by_year)

# Create US_tidied and UK_tidied
US_tidied <- tidy(US_fit)
UK_tidied <- tidy(UK_fit)

# Combine the two tidied models
bind_rows(US_tidied,UK_tidied)

###############Nesting a Data Frame############################
##Right now, the by_year_country data frame has one row per country-vote pair. 
##So that you can model each country individually, we're going to "nest" all columns besides country, 
#which will result in a data frame with one row per country. The data for each individual country will 
##then be stored in a list column called data.

##Save the by_year_country to a new data frame (removes earlier grouping by year)
by_year_country <- tbl_df(by_year_country)
# Load the tidyr package
library(tidyr)
# Nest all columns besides country
by_year_country %>%
  nest(-country)

##This "nested" data has an interesting structure. The second column, data, is a list, 
##a type of R object that allows complicated objects to be stored within each row. 
##This is because each item of the data column is itself a data frame.

# All countries are nested besides country
nested <- by_year_country %>%
  nest(-country)

# Print the nested data for Brazil
nested$data[[7]]

##The opposite of the nest() operation is the unnest() operation. 
##This takes each of the data frames in the list column and brings those rows back to the main data frame.
# Unnest the data column to return it to its original form
nested %>%
  unnest(data)


#################Tidying several models###################
##The map() function from purrr works by applying a formula to each item in a list.

# Load tidyr and purrr
library(tidyr)
library(purrr)
library(dplyr)
library(broom)
# Perform a linear regression on each item in the data column
by_year_country %>%
  nest(-country) %>%
  mutate(model = map(data,~lm(percent_yes~year,data=.)))

# Add another mutate that applies tidy() to each model
by_year_country %>%
  nest(-country) %>%
  mutate(model = map(data, ~ lm(percent_yes ~ year, data = .))) %>%
  mutate(tidied = map(data,~tidy(lm(percent_yes~year,data=.))))


# Add one more step that unnests the tidied column
country_coefficients <-
  by_year_country %>%
  nest(-country) %>%
  mutate(model = map(data, ~ lm(percent_yes ~ year, data = .)),
         tidied = map(model, tidy)) %>%
  unnest(tidied)

# Print the resulting country_coefficients variable
country_coefficients

################Filtering model elements#######################
# Print the country_coefficients dataset
country_coefficients

# Filter for only the slope terms
country_coefficients %>%
  filter(term == "year")

##Not all slopes are significant, and you can use the p-value to guess which are and which are not.
##However, when you have lots of p-values, like one for each country, you run into the problem of 
##multiple hypothesis testing, where you have to set a stricter threshold. 
##The p.adjust() function is a simple way to correct for this, where p.adjust(p.value) 
##on a vector of p-values returns a set that you can trust.

# Filter for only the slope terms
slope_terms <- country_coefficients %>%
  filter(term == "year")

# Add p.adjusted column, then filter
slope_terms %>%
  mutate(p.adjusted = p.adjust(p.value)) %>%
  filter(p.adjusted < .05)




