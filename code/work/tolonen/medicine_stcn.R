### ensin valitaan medicine ja tehdään siitä oma joukko

yy2 <- stcn[grep("medicine", stcn$genre),]

### sitten toinen joukko jossa myös academic text

yy3 <- yy2[grep("academic text", yy2$genre),]

yy4 <- yy2[!grepl("academic text",yy2$genre),]

###

### academic text vs not academic text Latin all

myvars <- as.vector(c("publication_year", "language_all"))
a1 = yy3[myvars]
b1 = yy4[myvars]

a1$cat <- "academic medicine"
b1$cat <- "non-academic medicine"

g1 <- rbind(a1, b1)

g2 <- g1 %>% group_by(publication_year, cat, language_all) %>%
  arrange(publication_year) %>%
  summarize(n = n())

top <- rev(rev(sort(table(g2$language_all)))[1:3])

g2 <- g2 %>% filter(language_all %in% names(top))

ggplot(g2, aes(x=publication_year, y=n, group=language_all, colour=language_all)) +
  geom_point() +
  stat_smooth(method = 'loess')   + theme_classic() + grids(linetype = "dashed") +
  facet_wrap(~cat, scales = "free") 

####

top <- rev(rev(sort(table(stcn$language_all)))[1:1])

yy1 <- stcn %>% filter(language_all %in% names(top))

top <- rev(rev(sort(table(yy2$genre_02)))[1:10])

yy2 <- yy2 %>% filter(genre_02 %in% names(top))


###

top <- rev(rev(sort(table(yy2$genre_02)))[1:10])

yy2 <- yy2 %>% filter(genre_02 %in% names(top))

###

ss2 <- yy2 %>% group_by(publication_year, language_all, genre_02) %>%
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
  labs(title="theology subject topics; top-3 language_all") +
  facet_wrap(~genre_02, scales = "free") 

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
