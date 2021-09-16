stcn <- catalogs$stcn

stcn$genre <- tolower(stcn$genre)

top <- rev(rev(sort(table(stcn$language_all)))[1:3])

yy <- stcn %>% filter(language_all %in% names(top))

yy <- yy[grep("theology", yy$genre),]

## practical

yy1 <- yy[grep("practical", yy$genre),]

yy2 <- yy[grep("dialogues", yy$genre),]

yy3 <- yy[grep("children's books", yy$genre),]

yy4 <- yy[grep("poetry", yy$genre),]

yy5 <- yy[grep("education", yy$genre),]

yy6 <- yy[grep("prayer books", yy$genre),]

yy7 <- yy[grep("pedagogy", yy$genre),]

yy8 <- yy[grep("songbooks", yy$genre),]

yy9 <- yy[grep("catechisms", yy$genre),]

yy10 <- yy[grep("liturgical works", yy$genre),]

yy11 <- yy[grep("sermons", yy$genre),]


###

myvars <- as.vector(c("publication_year", "language_all", "record_id"))
a1 = yy1[myvars]
b1 = yy2[myvars]
c1 = yy3[myvars]
d1 = yy4[myvars]
e1 = yy5[myvars]
f1 = yy6[myvars]
g1 = yy7[myvars]
h1 = yy8[myvars]
i1 = yy9[myvars]
j1 = yy10[myvars]
k1 = yy11[myvars]

g1 <- rbind(a1, b1, c1, d1, e1, f1, g1, h1, i1, j1, k1)

g1$cat <- "practical"

g2 <- g1 %>% distinct(record_id, .keep_all = TRUE)

### academic

mm1 <- yy[grep("academic", yy$genre),]

myvars <- as.vector(c("publication_year", "language_all", "record_id"))
a1 = mm1[myvars]

a1$cat <- "academic"

a2 <- a1 %>% distinct(record_id, .keep_all = TRUE)

### history

uu1 <- yy[grep("history", yy$genre),]

myvars <- as.vector(c("publication_year", "language_all", "record_id"))
q1 = uu1[myvars]

q1$cat <- "history"

q2 <- q1 %>% distinct(record_id, .keep_all = TRUE)

#### ei-mikään näistä

rr1 <- yy %>% filter(!record_id %in% g2$record_id)

rr1 <- rr1 %>% filter(!record_id %in% a2$record_id)

rr1 <- rr1 %>% filter(!record_id %in% q2$record_id)

myvars <- as.vector(c("publication_year", "language_all", "record_id"))
r1 = rr1[myvars]

r1$cat <- "others"

r2 <- r1 %>% distinct(record_id, .keep_all = TRUE)

####

j1 <- rbind(g2, a2, q2, r2)

myvars <- as.vector(c("publication_year", "language_all", "cat"))
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
j1$language_all <- droplevels(j1$language_all)
mycols <- cols[as.character(levels(j1$language_all))]


mypics <- list()
for (cate in rev(unique(j1$cat))) {

  p <- ggplot(subset(j1, cat==cate), aes(x=publication_year, y=n,
                      fill=language_all,
		      colour=language_all)) +
  geom_point() +
  stat_smooth(method = 'loess', se=FALSE) + 
  labs(x = "Publication year", y = "Title count (N)",
       color="", fill="", title=cate) + 
  theme_comhis("discrete", base_size=20) +
  scale_color_manual(values=mycols) +
  scale_fill_manual(values=mycols) 

  mypics[[cate]] <- p

}


# get legend from p1
l <- get_legend(mypics[[1]])

# remove legends
for (i in 1:length(mypics)) {
  mypics[[i]] <- mypics[[i]] + theme(legend.position = "none")
}

mypics[[1]] <- mypics[[1]] + theme(legend.position=c(0.13, 0.78))
p <- (mypics[[1]] + mypics[[2]] + mypics[[3]] + mypics[[4]])


CairoJPEG("Figure10.jpg", width=2*500, height=1.4*500, quality=100)
print(p)
dev.off()


