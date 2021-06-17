catalog <- "stcn";
dat <- read.csv("data/final/stcn-basic-fields.csv")

dat <- dat %>% rename(language_primary = lang_pub) %>%
	       rename(publication_country = country) 

dat$publication_year = as.numeric(dat$date_pub)
dat$date_pub <- NULL

# Combine authors
dat$author <- apply(dat[, c("primary_author", "secondary_author")], 1, function (x) {paste(x[!is.na(x)], collapse = "|")})
dat$author[dat$author == ""] <- NA
dat$primary_author <- NULL
dat$secondary_author <- NULL

fields <- c("record_id",
       "title",
       "dimensions",
       "language_primary",
       "publication_year",
       "publication_country",
       "author",
       "printer",
       "stcn_printer")

dat <- dat[, fields]

# -------------------------------------------------------------------------

# Add polished page counts
x <- read.csv("data/final/stcn-pagecounts.csv")
dat$pagecount <- x$pagecount

# -----------------------------------------

# Polish language
dat$languages_all <- gsub("\\|", ";", dat$language_primary)
dat$language_primary <- stringr::str_split_fixed(dat$languages_all, ";", n = 2)[,1]
dat$language_other <- gsub(";", ";", stringr::str_split_fixed(dat$languages_all, ";", n = 2)[,2])
dat$multilingual <- sapply(stringr::str_split(dat$languages_all, ";"), length) > 1

# ------------------------------------------------------------------------

# Add polished locatins
x <- read.csv("data/final/stcn-location.csv")
dat$publication_place <- x$location

# --------------------------------------------------------------------------

# Add decade
dat$publication_decade <- comhis::decade(dat$publication_year)

# ------------------------------------------------------------------