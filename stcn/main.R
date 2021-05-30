source("init.R")
source("data.R")

# STCN countries
country <- "nl"
subdat <- dat[dat$country %in% country,]
# Save the selected subset
saveRDS(subdat, file = "stcn_subset.rds")



