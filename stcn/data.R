catalog <- "stcn";
dat <- read.csv("data/stcn/stcn/data/final/stcn-basic-fields.csv")

dat$language_primary <- dat$lang_pub
dat$publication_year <- as.numeric(dat$date_pub)
dat$publication_country <- dat$country

# pagecounts: integrate -
#~/proj/article_2021_vernacular/stcn/data/stcn-physical-extent