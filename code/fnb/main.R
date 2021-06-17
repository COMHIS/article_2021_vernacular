source("init.R")
source("data.R")

# FNB countries
country <- c("Finland")
subdat <- dat %>% filter(publication_country %in% country)

fields <- c("original_row","publication_place","publication_country","multilingual","languages","language_primary","author_name","title","pagecount","gatherings","width","height","publisher","author","publication_year","publication_decade")
subdat <- subdat[, fields]

# Save the selected subset
saveRDS(subdat, file = "fnb_subset.rds")





