source("init.R")
source("data.R")

# FNB countries
country <- c("Finland")
subdat <- dat # %>% filter(publication_country %in% country)

fields <- c("original_row","publication_place","publication_country","multilingual",
"language_primary","language_other","language_all",
"language_latin_primary","language_latin_secondary",
"language_vernacular_primary","language_vernacular_secondary",
"author_name","title","pagecount","gatherings","width","height","publisher","author",
"publication_year","publication_decade",
"dissertation", "subject_topic")
subdat <- subdat[, fields]

# Save the selected subset
saveRDS(subdat, file = "fnb_subset.rds")






