catalog <- "snb";
dat <- readRDS("../snb/data/unified/polished/df.Rds")


# dat <- dat %>% rename(language_all = languages)
dat$languages <- NULL
dat$language_latin_primary <-  grepl("Latin", dat$language_primary)
dat$language_vernacular_primary <-  grepl("Swedish", dat$language_primary)
