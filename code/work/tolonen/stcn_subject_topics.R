urlfile= "https://media.githubusercontent.com/media/COMHIS/stcn/master/data/final/stcn-basic-fields.csv?token=ACPSTVEHCDAA7JEYCIK532TA2CIJA"

library(curl)

mydata<-read_csv(url(urlfile))

x <- read.csv(file=urlfile, sep = ',',header = TRUE, stringsAsFactors = FALSE, na.strings = c("", "NA"))

###

split_into_multiple <- function(column, pattern = ", ", into_prefix){
  cols <- str_split_fixed(column, pattern, n = Inf)
  # Sub out the ""'s returned by filling the matrix to the right, with NAs which are useful
  cols[which(cols == "")] <- NA
  cols <- as.tibble(cols)
  # name the 'cols' tibble as 'into_prefix_1', 'into_prefix_2', ..., 'into_prefix_m' 
  # where m = # columns of 'cols'
  m <- dim(cols)[2]
  
  names(cols) <- paste(into_prefix, 1:m, sep = "_")
  return(cols)
}

xde <- x %>% 
  bind_cols(split_into_multiple(.$genre, "|", "genre")) %>% 
  # selecting those that start with 'type_' will remove the original 'type' column
  select(record_id, starts_with("genre"))

xde %>% 
  gather(key, val, -record_id, na.rm = T)

####

ww1 <- x

library(splitstackshape)
ww2 <- cSplit(ww1, 'genre', ':|\\|', fixed = FALSE)

q2 <- ww2$genre_02

myvars <- as.vector(c("actor_id", "actor_name_primary", "estc_id", "pubyear", "publoc", "work_id"))
ff3 = ff3[myvars]

b1 = ff3[myvars]
hh2 <- hh1 %>% group_by(publication_year.x, group) %>%
  arrange(publication_year.x) %>%
  summarize(n = n())



q3 <- rbind(q1, q1)

###

myvars <- as.vector(c("genre_01", "genre_02", "genre_03", "genre_04", "genre_05", "genre_06", "genre_07", "genre_08", "genre_09", "genre_10", "genre_11", "genre_12", "genre_13"))

ww3 = ww2[myvars]


ww3 <- melt(ww2, id.vars = "name", measure.vars = c("test1","test2","test3"))

###

myvars <- as.vector(c("genre_01"))

ww3 = ww2[myvars]

ww5 <- ww2 %>% group_by(genre_05) %>%
  arrange(genre_05) %>%
  summarize(n = n())

ww5 <- ww2 %>% group_by(genre_01, genre_02, genre_03, genre_04, genre_05, genre_06, genre_07, genre_08, genre_09, genre_10, genre_11, genre_12, genre_13) %>%
  arrange(genre_01) %>%
  summarize(n = n())



write.csv(ww2, file = 'stcn_genret_kaikki', row.names = FALSE)
