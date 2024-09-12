yy <- stcn[grep("academic text", stcn$genre),]

top <- rev(rev(sort(table(yy$publication_place)))[3:3])

yy <- yy %>% filter(publication_place %in% names(top))

yy1 <- yy[grep("law", yy$genre),]

yy2 <- yy[grep("medicine", yy$genre),]

yy3 <- yy[grep("christian doctrine", yy$genre),]

yy4 <- yy[grep("philosophy", yy$genre),]

yy5 <- yy[grep("bible", yy$genre),]

yy6 <- yy[grep("theology", yy$genre),]

yy7 <- yy[grep("physics", yy$genre),]

yy8 <- yy[grep("judaism", yy$genre),]

yy9 <- yy[grep("astronomy", yy$genre),]

yy10 <- yy[grep("biology", yy$genre),]


###

myvars <- as.vector(c("publication_year", "language_all"))
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


a1$cat <- "law"
b1$cat <- "medicine"
c1$cat <- "christian doctrine"
d1$cat <- "philosophy"
e1$cat <- "bible"
f1$cat <- "theology"
g1$cat <- "physics"
h1$cat <- "judaism"
i1$cat <- "astronomy"
j1$cat <- "biology"


g1 <- rbind(a1, b1, c1, d1, e1, f1, g1, h1, i1, j1)

###

ss2 <- g1 %>% group_by(publication_year, language_all, cat) %>%
  arrange(publication_year) %>%
  summarize(n = n())

ss2 <- ss2 %>% drop_na(publication_year)

####

top <- rev(rev(sort(table(ss2$language_all)))[1:3])

ss2 <- ss2 %>% filter(language_all %in% names(top))

ss2 <- ss2 %>% filter(publication_year < 1801)

ggplot(ss2, aes(x=publication_year, y=n, group=language_all, colour=language_all)) +
  geom_point() +
  stat_smooth(method = 'loess')   + theme_classic() + grids(linetype = "dashed") +
  labs(title="Amsterdam academic text sub-categories; top-3 language_all") +
  facet_wrap(~cat, scales = "free") 

+
  scale_x_discrete(breaks = seq(from = 1500, to = 1800, by = 50))

+ theme(axis.text.x = element_text(angle = 90, size = 11))




###

gg2 <- stcn %>% filter(language_vernacular_all == FALSE)

gg4 <- gg2 %>% group_by(genre) %>%
  arrange(genre) %>%
  summarize(n = n())

### academic text vs not academic text Latin all

jj9 <- stcn[!grepl("Academic", stcn$genre),]

jj8 <- jj8[grepl("Latin", jj9$language_all),]

myvars <- as.vector(c("publication_year", "publication_place"))
a1 = jj8[myvars]
b1 = jj9[myvars]

a1$cat <- "academic text"
b1$cat <- "not academic text"

g1 <- rbind(a1, b1)

g2 <- g1 %>% group_by(publication_year, cat, publication_place) %>%
  arrange(publication_year) %>%
  summarize(n = n())

top <- rev(rev(sort(table(g2$publication_place)))[1:8])

g2 <- g2 %>% filter(publication_place %in% names(top))

ggplot(g2, aes(x=publication_year, y=n, group=cat, colour=cat)) +
  geom_point() +
  stat_smooth(method = 'loess')   + theme_classic() + grids(linetype = "dashed") +
  facet_wrap(~publication_place, scales = "free") 

+ ylim(0,200) 

+
  labs(title="academic text vs in genre; vernacular vs latin")

###

bb1 <- stcn[grep("occasional writings", stcn$genre),]

gg2 <- stcn %>% filter(genre == "occasional writings")
