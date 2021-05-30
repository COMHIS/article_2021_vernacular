catalog <- "fnb";
dat <- readRDS("../fnb/data/unified/polished/df.Rds")

# FNB countries
country <- c("Finland")
subdat <- dat %>% filter(publication_country %in% country)
# Save the selected subset
saveRDS(subdat, file = "fnb_subset.rds")

