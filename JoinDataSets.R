
# Print the votes_processed dataset
votes_processed

# Print the descriptions dataset
descriptions

# Join them together based on the "rcid" and "session" columns
votes_joined <-
  votes_processed %>%
  inner_join(descriptions,by = c("rcid","session"))

##There are six columns in the descriptions dataset (and therefore in the new joined dataset) 
##that describe the topic of a resolution:
# me: Palestinian conflict
# nu: Nuclear weapons and nuclear material
# di: Arms control and disarmament
# hr: Human rights
# co: Colonialism
# ec: Economic development

# Filter for votes related to colonialism
votes_joined %>%
  filter(co==1)

# Load the ggplot2 package
library(ggplot2)

# Filter, then summarize by year: US_co_by_year
US_co_by_year <- 
  votes_joined %>%
  filter(co==1,country == "United States of America") %>%
  group_by(year) %>%
  summarize(percent_yes = mean(vote==1))

# Graph the % of "yes" votes over time
ggplot(US_co_by_year,
       aes(year,percent_yes)) + geom_line()

##In order to represent the joined vote-topic data in a tidy form so we can analyze and graph by topic, 
##we need to transform the data so that each row has one combination of country-vote-topic. 
##This will change the data from having six columns (me, nu, di, hr, co, ec) to having two columns (topic and has_topic).

# Load the tidyr package
library(tidyr)

# Gather the six mu/nu/di/hr/co/ec columns
votes_joined %>%
  gather(topic,has_topic,me:ec)

# Perform gather again, then filter
votes_gathered <-
  votes_joined %>%
  gather(topic,has_topic,me:ec) %>%
  filter(has_topic == 1)

# Replace the two-letter codes in topic: votes_tidied
votes_tidied <- votes_gathered  %>%
  mutate(topic = recode(topic,
                        me = "Palestinian conflict",
                        nu = "Nuclear weapons and nuclear material",
                        di = "Arms control and disarmament",
                        hr = "Human rights",
                        co = "Colonialism",
                        ec = "Economic development"))

# Print votes_tidied
votes_tidied

# Summarize the percentage "yes" per country-year-topic
by_country_year_topic <-
  votes_tidied %>%
  group_by(country,year,topic) %>%
  summarize(total = n(),percent_yes = mean(vote==1)) %>%
  ungroup(country,year,topic)

# Print by_country_year_topic
by_country_year_topic

# Load the ggplot2 package
library(ggplot2)

# Filter by_country_year_topic for just the US
US_by_country_year_topic <-
  by_country_year_topic %>%
  filter(country=="United States")

# Plot % yes over time for the US, faceting by topic
ggplot(US_by_country_year_topic,
       aes(year,percent_yes, color = topic)) + geom_line() + facet_wrap(~topic)


# Load purrr, tidyr, and broom
library(purrr)
library(tidyr)
library(broom)
# Print by_country_year_topic
by_country_year_topic

# Fit model on the by_country_year_topic dataset
country_topic_coefficients <-
  by_country_year_topic %>%
  nest(-country,-topic) %>%
  mutate(model = map(data,~lm(percent_yes~year,data=.)),
         tidied = map(model,tidy)) %>%
  unnest(tidied)

# Print country_topic_coefficients
country_topic_coefficients

##You'll also have to extract only cases that are statistically significant, which means 
##adjusting the p-value for the number of models, and then filtering to include only significant changes.
# Create country_topic_filtered
country_topic_filtered <-
  country_topic_coefficients %>%
  filter(term == "year") %>%
  mutate(p.adjusted = p.adjust(p.value)) %>%
  filter(p.adjusted < .05)
##If we arrange country_topic_filtered on estimate that will give the countries with st slope
##Vanuatu changed its votes mostly on Palestinian conflict
country_topic_filtered %>%
  arrange(estimate)

##Lets check details of Vanuatu
# Create vanuatu_by_country_year_topic
vanuatu_by_country_year_topic <- 
  by_country_year_topic %>%
  filter(country == "Vanuatu")

# Plot of percentage "yes" over time, faceted by topic
library(ggplot2)
ggplot(vanuatu_by_country_year_topic,
       aes(year,percent_yes,color=topic)) + geom_line() + facet_wrap(~topic)









