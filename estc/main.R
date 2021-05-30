source("init.R")
source("data.R")

country <- "England"
subdat <- dat %>% filter(publication_country == country)
# Save the selected subset
saveRDS(subdat, file = "estc_subset.rds")



