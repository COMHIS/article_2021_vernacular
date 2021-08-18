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
       "genre",
       "language_primary",
       "publication_country",
       "publication_year",
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
library(stringr)

  # Convert to polished language names as in
  # http://www.loc.gov/marc/languages/language_code.html
  # TODO: XML version available, read directly in R:
  # see http://www.loc.gov/marc/languages/
abrv <- read.csv("language_abbreviations.csv", sep = "\t", header = TRUE, encoding = "UTF-8")
m <- mark_languages(gsub("\\|", ";", dat$language_primary), abrv)

dat$language_primary <- NULL
dat <- bind_cols(dat, m)
dat <- dat %>% rename(language_all = languages)
dat$language_other <- gsub(";", ";", stringr::str_split_fixed(dat$language_all, ";", n = 2)[,2])
dat$language_vernacular_all <- grepl("Dutch", dat$language_all)
dat$language_vernacular_primary <- grepl("Dutch", dat$language_primary)
dat$language_vernacular_secondary <- grepl("Dutch", dat$language_other)
dat$language_latin_primary <- grepl("Latin", dat$language_primary)
dat$language_latin_secondary <- grepl("Latin", dat$language_other)

# ------------------------------------------------------------------------

# Add decade and century
dat$publication_decade <- comhis::decade(dat$publication_year)
dat$publication_century <- comhis::century(dat$publication_year)

# Recognize "173X"
inds <- grep("[0-9]{3}X", dat$date_pub)
dat$publication_decade[inds] <- gsub("X$", "0", dat$date_pub[inds])
dat$publication_decade <- as.numeric(dat$publication_decade)

# Recognize "17XX"
inds <- grep("[0-9]{2}XX", dat$date_pub)
dat$publication_century[inds] <- gsub("XX$", "00", dat$date_pub[inds])
dat$publication_century <- as.numeric(dat$publication_century)

# ------------------------------------------------------------------

# Standardize gatherings names
dat$gatherings <- dat$dimensions
dat$gatherings <- stringr::str_remove(dat$gatherings,"[O|o]blong")
dat$gatherings <- stringr::str_remove(dat$gatherings,"[A|a]genda")
dat$gatherings <- stringr::str_remove(dat$gatherings,"^ *")
dat$gatherings <- stringr::str_remove(dat$gatherings," *$")
dat$gatherings <- stringr::str_remove(dat$gatherings," ")
dat$gatherings <- stringr::str_replace(dat$gatherings, "^4$", "4°")
dat$gatherings <- stringr::str_replace(dat$gatherings, "^8$", "8°")
dat$gatherings <- stringr::str_replace(dat$gatherings, "^12$", "12°")
dat$gatherings <- stringr::str_replace(dat$gatherings, "^14$", "14°")
dat$gatherings <- stringr::str_replace(dat$gatherings, "^16$", "16°")
#s <- sort(table(dat$gatherings))
#nam <- names(s)
#nam2 <- map(comhis::polish_gatherings(nam), gatherings_table(), from = "Symbol", to="Short")
#cbind(nam, nam2, s)
# over 99.9% harmonized
dat$gatherings <- map(comhis::polish_gatherings(dat$gatherings), gatherings_table(), from = "Symbol", to="Short")
dat$dimensions <- NULL

# ------------------------------------------------------------------

# Pamphlet / Book info
dat$document_type <- cut(dat$pagecount, breaks = c(0, 32, 128,Inf), include.lowest = TRUE, labels = c("Pamphlet","Intermediate","Book"))

# ------------------------------------------------------------------

# Add polished locatins
# Older option - not harmonized / MJ?
# x <- read.csv("data/final/stcn-location.csv")
# From IT, in sync with other catalogs
geo <- read.csv("../../input/geomapping_process/data_output/stcn_geomapped.csv")
geo.match <- geo[match(dat$record_id, geo$system_control_number),]
dat <- dat %>% rename(publication_country_in_stcn = publication_country)
dat$publication_place <- geo.match$publication_place
dat$publication_country <- geo.match$publication_country
# Note that publication_country comes straight from STCN field
# and is not always in sync with IT geomapping, to be curated
