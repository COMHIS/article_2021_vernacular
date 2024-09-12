stcn <- catalogs$stcn
stcn$genre <- tolower(stcn$genre)

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
a1$cat <- "Academic medicine"
b1$cat <- "Non-academic medicine"
g1 <- rbind(a1, b1)
g2 <- g1 %>% group_by(publication_year, cat, language_all) %>%
  arrange(publication_year) %>%
  summarize(n = n())
top <- rev(rev(sort(table(g2$language_all)))[1:3])
g2 <- g2 %>% filter(language_all %in% names(top)) %>%
             mutate(language_all=droplevels(language_all))

cols <- default_colors("language")
mycols <- cols[as.character(levels(g2$language_all))]
p <- ggplot(g2, aes(x=publication_year, y=n,
      group=language_all, colour=language_all)) +
  geom_point() +
  stat_smooth(method = 'loess') + 
  facet_wrap(~cat, scales = "free") +
  scale_y_continuous(limits = range(g2$n)) + 
  theme_comhis("discrete", base_size=20) +
  scale_color_manual(values=mycols) +
  scale_fill_manual(values=mycols) +     
  labs(x="Publication year", y="Title count (N)", color="")


CairoJPEG("Figure9.jpg", width=1*1000, height=1*500, quality=100)
print(p)
dev.off()



