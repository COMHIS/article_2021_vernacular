library(dplyr)
library(tidyr)

## put together relevant tables for stcv

# title

cc1 <- read.csv(file="stcv_title.csv", sep = ',',header = FALSE, stringsAsFactors = FALSE)

cc1 <- cc1 %>% filter(V11 == "h")

myvars <- as.vector(c("V3", "V10"))
c1 = cc1[myvars]

names(c1)[1] <- "stcv_id"
names(c1)[2] <- "title"

c1 <- c1 %>% distinct(stcv_id, .keep_all = TRUE)

### imprint info

cc2 <- read.csv(file="stcv_impressum.csv", sep = ',',header = FALSE, stringsAsFactors = FALSE)

myvars <- as.vector(c("V3", "V6", "V18"))
c2 = cc2[myvars]

names(c2)[1] <- "stcv_id"
names(c2)[2] <- "publication_year"
names(c2)[3] <- "publisher"

c2 <- c2 %>% distinct(stcv_id, .keep_all = TRUE)

### author info

cc3 <- read.csv(file="stcv_author.csv", sep = ',',header = FALSE, stringsAsFactors = FALSE)

myvars <- as.vector(c("V6", "V10", "V11", "V13"))
c3 = cc3[myvars]

names(c3)[1] <- "actor_role"
names(c3)[2] <- "author_name"
names(c3)[3] <- "author_years"
names(c3)[4] <- "stcv_id"

c3 <- c3 %>% filter(actor_role == "aut")

c3 <- c3 %>% distinct(stcv_id, .keep_all = TRUE)

### language

cc4 <- read.csv(file="stcv_language.csv", sep = ',',header = FALSE, stringsAsFactors = FALSE)

cc4 <- cc4 %>% filter(!V5 == "bt")

myvars <- as.vector(c("V3", "V4"))
c4 = cc4[myvars]

names(c4)[1] <- "stcv_id"
names(c4)[2] <- "language"

sink('stcv_language_row.txt')

uvals = unique(c4[,1])
for(uIDX in c(1:length(uvals))) {
  gname = uvals[uIDX]
  IDX = which(c4[,1] == gname)
  cat(sprintf("%s\t%s\n", gname, paste0(c4[IDX,2], collapse=";")))
}

sink()

c5 <- read.delim("stcv_language_row.txt", header = FALSE )

names(c5)[1] <- "stcv_id"
names(c5)[2] <- "language"

c5 <- c5 %>% distinct(stcv_id, .keep_all = TRUE)

# Polish language
library(stringr)

  # Convert to polished language names as in
  # http://www.loc.gov/marc/languages/language_code.html
  # TODO: XML version available, read directly in R:
  # see http://www.loc.gov/marc/languages/
abrv <- read.csv("language_abbreviations.csv", sep = "\t", header = TRUE, encoding = "UTF-8")
source("../funcs.R")
library(comhis)
dat <- mark_languages(gsub("\\|", ";", c5$language), abrv)
dat <- dat %>% rename(language_all = languages)
dat$language_other <- gsub(";", ";", stringr::str_split_fixed(dat$language_all, ";", n = 2)[,2])
dat$language_vernacular_all <- grepl("Dutch", dat$language_all)
dat$language_vernacular_primary <- grepl("Dutch", dat$language_primary)
dat$language_vernacular_secondary <- grepl("Dutch", dat$language_other)
dat$language_latin_primary <- grepl("Latin", dat$language_primary)
dat$language_latin_secondary <- grepl("Latin", dat$language_other)
dat$stcv_id <- c5$stcv_id
c5 <- dat


## subject topic

cc6 <- read.csv(file="stcv_subject.csv", sep = ',',header = FALSE, stringsAsFactors = FALSE)

cc6 <- cc6 %>% filter(!V4 == "STY")

cc6 <- cc6 %>% filter(!V4 == "SPA")

cc6 <- cc6 %>%
  pivot_wider(names_from = V4, values_from = V5)

myvars <- as.vector(c("V2", "SOW", "SPT"))
c6 = cc6[myvars]

names(c6)[1] <- "stcv_id"
names(c6)[2] <- "subject_heading"
names(c6)[3] <- "document_type"

## subject heading matched on same row

myvars <- as.vector(c("stcv_id", "subject_heading"))
a1 = c6[myvars]

sink('stcv_subject_heading_row.txt')

a1=as.data.frame(a1)

a1 <- a1 %>% drop_na()

uvals = unique(a1[,1])
for(uIDX in c(1:length(uvals))) {
  gname = uvals[uIDX]
  IDX = which(a1[,1] == gname)
  cat(sprintf("%s\t%s\n", gname, paste0(a1[IDX,2], collapse=";")))
}

sink()

a1 <- read.delim("stcv_subject_heading_row.txt", header = FALSE )

names(a1)[1] <- "stcv_id"
names(a1)[2] <- "subject_heading"

a1 <- a1 %>% distinct(stcv_id, .keep_all = TRUE)

### document type matched on same row

myvars <- as.vector(c("stcv_id", "document_type"))
b1 = c6[myvars]

sink('stcv_document_type_row.txt')

b1=as.data.frame(b1)

b1 <- b1 %>% drop_na()

uvals = unique(b1[,1])
for(uIDX in c(1:length(uvals))) {
  gname = uvals[uIDX]
  IDX = which(b1[,1] == gname)
  cat(sprintf("%s\t%s\n", gname, paste0(b1[IDX,2], collapse=";")))
}

sink()

b1 <- read.delim("stcv_document_type_row.txt", header = FALSE )

names(b1)[1] <- "stcv_id"
names(b1)[2] <- "document_type"

b1 <- b1 %>% distinct(stcv_id, .keep_all = TRUE)

c6 <- merge(a1, b1, by.x="stcv_id", by.y="stcv_id", all=TRUE)

### then we merge all of these

srf <- merge(c1, c2, by.x="stcv_id", by.y="stcv_id", all=TRUE)

srf2 <- merge(srf, c3, by.x="stcv_id", by.y="stcv_id", all=TRUE)

srf3 <- merge(srf2, c5, by.x="stcv_id", by.y="stcv_id", all=TRUE)

srf4 <- merge(srf3, c6, by.x="stcv_id", by.y="stcv_id", all=TRUE)

### adding places

# Use local symbolic path
file= "../../input/geomapping_process/data_output/stcv_geomapped.csv"
c9 <-readr::read_csv(file)

srf4$publication_place <- c9$publication_place[match(srf4$stcv_id, c9$system_control_number)]

###

write.csv(srf4, file = 'stcv.csv', row.names = FALSE)

# Save 
saveRDS(srf4, file = "stcv_subset.rds")