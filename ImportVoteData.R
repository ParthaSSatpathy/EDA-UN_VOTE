##Import the UN vote data

##Reads a file in table format and creates a data frame from it
##Read the data from github
x <- read.delim("https://github.com/datasciencelabs/data/raw/master/rawvotingdata13.tab")

##To view the data frame in a better format and save it as votes
votes <- tbl_df(x)

##View the intial 10 rows
head(votes,10)

##View the structuure of the data
str(votes)