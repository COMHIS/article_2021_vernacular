source("init.R")
source("data.R")

fields <- c("original_row", "publication_country","publication_place","multilingual","language_primary","author_name","title", "pagecount","publisher","author","publication_year","publication_decade","gatherings","width","height","singlevol", "multivol")

# ------------------------------------------------------------------------

# No other lang info than primary, at least not fetched yet from the raw data
# language == language_primary
dat <- dat[, fields]

# Save the selected subset
saveRDS(dat, file = "snb_subset.rds")

