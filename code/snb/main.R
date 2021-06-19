source("init.R")
source("data.R")

# SNB countries
country <- c("Sweden")
subdat <- dat %>% filter(publication_country %in% country)

fields <- c("original_row", "publication_country","publication_place","multilingual","language_primary","author_name","title", "pagecount","publisher","author","publication_year","publication_decade","gatherings","width","height","singlevol", "multivol")

# No other lang info than primary, at least not fetched yet from the raw data
# language == language_primary
subdat <- subdat[, fields]

# Save the selected subset
saveRDS(subdat, file = "snb_subset.rds")

