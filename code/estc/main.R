source("init.R")
source("data.R")

#places <- c("London", "Dublin", "Edinburgh", "Glasgow", "Oxford", "Cambridge", "Newcastle")
#subdat <- dat %>% dplyr::filter(publication_place %in% places)

# Save the selected subset
saveRDS(dat, file = "estc_subset.rds")


