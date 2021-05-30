source("init.R")
source("data.R")

# HPB countries
country <- c("Netherlands", "Austria", "Estonia")
subdat <- dat %>% filter(publication_country %in% country)
# Save the selected subset
saveRDS(subdat, file = "hpb_subset.rds")

