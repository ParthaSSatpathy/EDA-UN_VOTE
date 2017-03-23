##Data Visualization using ggplot2

library(ggplot2)

#########Visualizing by Year######################
by_year <- votes_processed %>% 
  group_by(year) %>% 
  summarize(total=n(),
            percent_yes=mean(vote==1))
##ggplot has 3 important parts to it
ggplot(by_year, #1. Data Set
       aes(x = year, y = percent_yes)) + #2. X and Y axis
       geom_line() #3. Layer - (type of) graph on the XY-plane

# Change to scatter plot and add smoothing curve
ggplot(by_year, aes(year, percent_yes)) +
  geom_point() +
  geom_smooth()

#########Visualizing by Year and Country######################

##Select the yearly data only for USA
by_year_country_USA <-
  votes_processed %>%
  group_by(year,country) %>% ##Here grou by on both year and country
  summarize(total=n(),percent_yes=mean(vote==1)) %>%
  filter(country == "United States of America")

##Select the yearly data only for USA and France
by_year_country_USA_France <-
  votes_processed %>%
  group_by(year,country) %>% ##Here grou by on both year and country
  summarize(total=n(),percent_yes=mean(vote==1)) %>%
  filter(country %in% c("United States of America","France")) ##Check the %in% for multiple selection

##Compare the US and Farnce data over the years
##For this we can distinguish between the two countries using color aesthetic
ggplot(by_year_country_USA_France,
       aes(x=year,y=percent_yes,color=country)) + geom_line()
       
# Start with by_year_country dataset
by_year_country <- votes_processed %>%
  group_by(year, country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Print by_year_country
by_year_country

# Create a filtered version: UK_by_year
UK_by_year <-
  by_year_country %>%
  filter(country=="United Kingdom of Great Britain and Northern Ireland")

# Line plot of percent_yes over time for UK only
ggplot(UK_by_year, aes(year,percent_yes)) + geom_line()

# Vector of four countries to examine
countries <- c("United States of America",
               "United Kingdom of Great Britain and Northern Ireland",
               "France", "India")

# Filter by_year_country: filterebd_4_countries
filtered_4_countries <-
  by_year_country %>%
  filter(country %in% countries)

# Line plot of % yes in four countries
ggplot(filtered_4_countries, aes(year,percent_yes,color=country))+geom_line()
