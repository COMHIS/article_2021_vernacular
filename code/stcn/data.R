catalog <- "stcn";
dat <- read.csv("data/stcn/stcn/data/final/stcn-basic-fields.csv")

dat <- dat %>% rename(language_primary = lang_pub) %>%
	       rename(publication_country = country) 

dat$publication_year = as.numeric(dat$date_pub)
dat$date_pub <- NULL

# Combine authors
dat$author <- apply(dat[, c("primary_author", "secondary_author")], 1, function (x) {paste(x[!is.na(x)], collapse = "|")})
dat$author[dat$author == ""] <- NA
dat$primary_author <- NULL
dat$secondary_author <- NULL

# pagecounts: integrate initially polished versions
# FIXME local to universal path 
x <- readRDS("~/data/comhis/STCN/stcn/stcn/data/final/stcn-physicalextent/physical_extent.Rds")
dat$pagecount <- x$pagecount

fields <- c("record_id",
       "title",
       "dimensions",
       "pagecount",
       "language_primary",
       "publication_year",
       "publication_country",
       "author",
       "printer",
       "stcn_printer")

dat <- dat[, fields]


