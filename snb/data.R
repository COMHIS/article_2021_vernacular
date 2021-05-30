catalog <- "snb";
dat <- readRDS("../snb/data/unified/polished/df.Rds")

# SNB countries
country <- c("Sweden")
subdat <- dat %>% filter(publication_country %in% country)
# Save the selected subset
saveRDS(subdat, file = "snb_subset.rds")

