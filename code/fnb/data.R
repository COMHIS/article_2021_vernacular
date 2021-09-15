catalog <- "fnb";
dat <- readRDS("../fnb/data/unified/polished/df.Rds")

dat <- dat %>% rename(language_all = languages)
dat$language_other <- gsub(";", ";", stringr::str_split_fixed(dat$language_all, ";", n = 2)[,2])

vernculars <- c("Finnish", "Swedish")
dat$language_vernacular_all       <- dat$language_all %in% vernculars
dat$language_vernacular_primary   <- dat$language_primary %in% vernculars
dat$language_vernacular_secondary <- dat$language_other %in% vernculars

dat$language_latin_all       <- grepl("Latin", dat$language_all)
dat$language_latin_primary   <- grepl("Latin", dat$language_primary)
dat$language_latin_secondary <- grepl("Latin", dat$language_other)


