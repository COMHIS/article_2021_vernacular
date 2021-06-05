source("init.R")
source("data.R")

places <- c("London", "Dublin", "Edinburgh", "Oxford", "Cambridge", "Newcastle")
subdat <- dat %>% filter(publication_place %in% places)

# Save the selected subset
saveRDS(subdat, file = "estc_subset.rds")


