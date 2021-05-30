source("init.R")
source("data.R")

# STCN countries
country <- "Netherlands"
subdat <- dat[dat$country %in% country,]
# Save the selected subset
saveRDS(subdat, file = "stcn_subset.rds")



