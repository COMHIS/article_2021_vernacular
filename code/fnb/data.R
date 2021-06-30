catalog <- "fnb";
dat <- readRDS("../fnb/data/unified/polished/df.Rds")

dat <- dat %>% rename(language_all = languages)
dat$language_other <- gsub(";", ";", stringr::str_split_fixed(dat$language_all, ";", n = 2)[,2])

dat$language_vernacular_all <- grepl("Swedish", dat$language_all)
dat$language_vernacular_primary <- grepl("Swedish", dat$language_primary)
dat$language_vernacular_secondary <- grepl("Swedish", dat$language_other)

dat$language_latin_all <- grepl("Latin", dat$language_all)
dat$language_latin_primary <- grepl("Latin", dat$language_primary)
dat$language_latin_secondary <- grepl("Latin", dat$language_other)


