##Pipe Operator- x %>% f(,y) tells you to pass the variable before the operator to the fuction f(x,y)
##It helps you chain a series of command together

##Deplyr verbs
##Filter() -> subsets the observation
##mutate() -> adds a new variable or modifies existing one

votes %>% filter(vote <= 3)
votes %>% mutate(year=session+1945)

##Combine the above 2 functions using pipe
votes %>%
  filter(vote <= 3) %>%
  mutate(year=session+1945)

# Load the countrycode package
library(countrycode)

# Convert country code 100
countrycode(100,"cown","country.name")

# Add a country column within the mutate: votes_processed
votes_processed <- votes %>%
  filter(vote <= 3) %>%
  mutate(year = session + 1945,country=countrycode(ccode,"cown","country.name"))

##summrize() turns many rows into one
votes_processed %>% summarize(total=n()) ##show the no of rowa

votes_processed %>%
  summarize(total=n(),percent_yes = mean(vote == 1))
##The above will fist compare if vote==1, it will consider true as 1 and false as 0,
##It will then calculate the mean. So finally it will give the percentages of yes

##summarize considers the whole group, but if we want to summarize at sub group levels
##we will use group_by
##Below code is to see no of votes and percentage of Yes for every year
##We will group the data set in years before summarizing
votes_processed %>%
  group_by(year) %>%
  summarize(total=n(),percent_yes = mean(vote == 1))

# Summarize by country: by_country
by_country <-
  votes_processed %>%
  group_by(country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

##arrange() sorts a table based on a variable
by_country %>% 
  arrange(percent_yes)

# Now sort in descending order
by_country %>%
  arrange(desc(percent_yes))

# Filter out countries with fewer than 100 votes
by_country %>%
  filter(total>100) %>%
  arrange(percent_yes)

## We may be interested in countries whose percentage of "yes" votes is changing most quickly over time. 
##Thus, we want to find the countries with the highest and lowest slopes; that is, the estimate column.

# Filter by adjusted p-values
filtered_countries <- country_coefficients %>%
  filter(term == "year") %>%
  mutate(p.adjusted = p.adjust(p.value)) %>%
  filter(p.adjusted < .05)

# Sort for the countries increasing most quickly
filtered_countries %>%
  arrange(desc(estimate))

# Sort for the countries decreasing most quickly
filtered_countries %>%
  arrange(estimate)



