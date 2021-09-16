stcn <- catalogs$stcn

# Top languages
top.lang <- rev(rev(sort(table(stcn$language_all)))[1:3])
top.place <- rev(rev(sort(table(stcn$publication_place)))[5])


df <- stcn %>% filter(language_all %in% names(top.lang)) %>%
               filter(publication_place %in% names(top.place))

# Select subsets for each genre
myvars <- c("publication_year", "language_all", "record_id")
yy <- yy[grep("theology", yy$genre), myvars]
## practical
a1 <- yy[grep("practical", yy$genre),]
b2 <- yy[grep("dialogues", yy$genre),]
c3 <- yy[grep("children's books", yy$genre),]
d4 <- yy[grep("poetry", yy$genre),]
e5 <- yy[grep("education", yy$genre),]
f6 <- yy[grep("prayer books", yy$genre),]
g7 <- yy[grep("pedagogy", yy$genre),]
h8 <- yy[grep("songbooks", yy$genre),]
i9 <- yy[grep("catechisms", yy$genre),]
j10 <- yy[grep("liturgical works", yy$genre),]
k11 <- yy[grep("sermons", yy$genre),]

g1 <- rbind(a1, b1, c1, d1, e1, f1, g1, h1, i1, j1, k1)
g1$cat <- "practical"
g2 <- g1 %>% distinct(record_id, .keep_all = TRUE)

### academic
mm1 <- yy[grep("academic", yy$genre),]
myvars <- as.vector(c("publication_year", "language_all", "record_id"))
a1 <- mm1[myvars]
a1$cat <- "academic"
a2 <- a1 %>% distinct(record_id, .keep_all = TRUE)

### history
uu1 <- yy[grep("history", yy$genre),]
q1 = uu1[myvars]
q1$cat <- "history"
q2 <- q1 %>% distinct(record_id, .keep_all = TRUE)

#### ei-mikään näistä
rr1 <- yy %>% filter(!record_id %in% g2$record_id)
rr1 <- rr1 %>% filter(!record_id %in% a2$record_id)
rr1 <- rr1 %>% filter(!record_id %in% q2$record_id)
r1 = rr1[myvars]
r1$cat <- "others"
r2 <- r1 %>% distinct(record_id, .keep_all = TRUE)

####
j1 <- rbind(g2, a2, q2, r2)
j1 = j1[myvars]
j1 <- j1 %>% drop_na(publication_year)
j1 <- j1 %>% group_by(publication_year, language_all, cat) %>%
  arrange(publication_year) %>%
  summarize(n = n())
j1 <- j1 %>% filter(publication_year < 1801)
j1$cat <- gsub("academic", "Academic", j1$cat)
j1$cat <- gsub("history", "History", j1$cat)
j1$cat <- gsub("others", "Others", j1$cat)
j1$cat <- gsub("practical", "Practical", j1$cat)
cols <- default_colors("language")
mycols <- cols[as.character(levels(j1$language_all))]

p <- ggplot(j1, aes(x=publication_year, y=n,
               group=language_all,
	       colour=language_all)) +
  geom_point() +
  stat_smooth(method = 'loess') +
  facet_wrap(~cat, scales = "free") +

  scale_color_manual(values=mycols) +   
  labs(x = "Publication year", y = "", color="") +
  theme_comhis("discrete", base_size=20) 

CairoJPEG("Figure10.jpg", width=1*1000, height=1*500, quality=100)
print(p)
dev.off()




