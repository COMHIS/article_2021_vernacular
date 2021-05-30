source("init.R")
source("data.R")

# Language analysis
knit(input = "../code/language.Rmd", output = "language.md")

# Place analysis for given country
library(dplyr)
country <- "England"
subdat <- dat %>% filter(publication_country == country)
knit(input = "../code/place.Rmd", output = "place.md")



