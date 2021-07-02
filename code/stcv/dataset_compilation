## put together relevant tables for stcv

# title

cc1 <- read.csv(file="stcv_title.csv", sep = ',',header = FALSE, stringsAsFactors = FALSE)

myvars <- as.vector(c("V3", "V10"))
c1 = cc1[myvars]

names(c1)[1] <- "stcv_id"
names(c1)[2] <- "title"

c1 <- c1 %>% distinct(stcv_id, .keep_all = TRUE)

### imprint info

cc2 <- read.csv(file="stcv_impressum.csv", sep = ',',header = FALSE, stringsAsFactors = FALSE)

myvars <- as.vector(c("V3", "V6", "V12", "V18"))
c2 = cc2[myvars]

names(c2)[1] <- "stcv_id"
names(c2)[2] <- "publication_year"
names(c2)[3] <- "publication_place"
names(c2)[4] <- "publisher"


c2 <- c2 %>% distinct(stcv_id, .keep_all = TRUE)

### author info

cc3 <- read.csv(file="stcv_author.csv", sep = ',',header = FALSE, stringsAsFactors = FALSE)

myvars <- as.vector(c("V6", "V10", "V11", "V13"))
c3 = cc3[myvars]

names(c3)[1] <- "actor_role"
names(c3)[2] <- "actor_name"
names(c3)[3] <- "actor_years"
names(c3)[4] <- "stcv_id"

c3 <- c3 %>% filter(actor_role == "aut")

c3 <- c3 %>% distinct(stcv_id, .keep_all = TRUE)

### language

cc4 <- read.csv(file="stcv_language.csv", sep = ',',header = FALSE, stringsAsFactors = FALSE)

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

## subject topic

cc6 <- read.csv(file="stcv_subject.csv", sep = ',',header = FALSE, stringsAsFactors = FALSE)

myvars <- as.vector(c("V2", "V5"))
c6 = cc6[myvars]

names(c6)[1] <- "stcv_id"
names(c6)[2] <- "subject_topic"

sink('stcv_subject_row.txt')

uvals = unique(c6[,1])
for(uIDX in c(1:length(uvals))) {
  gname = uvals[uIDX]
  IDX = which(c6[,1] == gname)
  cat(sprintf("%s\t%s\n", gname, paste0(c6[IDX,2], collapse=";")))
}

sink()

c6 <- read.delim("stcv_subject_row.txt", header = FALSE )

names(c6)[1] <- "stcv_id"
names(c6)[2] <- "subject_topic"

c6 <- c6 %>% distinct(stcv_id, .keep_all = TRUE)

### then we merge all of these

srf <- merge(c1, c2, by.x="stcv_id", by.y="stcv_id", all=TRUE)

srf2 <- merge(srf, c3, by.x="stcv_id", by.y="stcv_id", all=TRUE)

srf3 <- merge(srf2, c5, by.x="stcv_id", by.y="stcv_id", all=TRUE)

srf4 <- merge(srf3, c6, by.x="stcv_id", by.y="stcv_id", all=TRUE)

write.csv(srf4, file = 'stcv.csv', row.names = FALSE)
