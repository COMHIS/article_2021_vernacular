stcn$genre <- tolower(stcn$genre)
top <- rev(rev(sort(table(stcn$publication_place)))[2:2])
yy <- stcn %>% filter(publication_place %in% names(top))
yy1 <- yy[grep("law", yy$genre),]
yy2 <- yy[grep("theology", yy$genre),]
yy3 <- yy[grep("public and social administration", yy$genre),]
yy4 <- yy[grep("history", yy$genre),]
yy5 <- yy[grep("medicine", yy$genre),]
yy6 <- yy[grep("dutch language and literature", yy$genre),]
yy7 <- yy[grep("french language and literature", yy$genre),]
yy8 <- yy[grep("latin language and literature", yy$genre),]
yy9 <- yy[grep("philosophy", yy$genre),]
yy10 <- yy[grep("poetry", yy$genre),]
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

a1$cat <- "Law"

#b1$cat <- "theology"
#c1$cat <- "public and social administration"

d1$cat <- "History"
e1$cat <- "Medicine"

f1$cat <- "Dutch language and literature"
#g1$cat <- "french language and literature"
#h1$cat <- "latin language and literature"
i1$cat <- "Philosophy"
#j1$cat <- "poetry"
#g1 <- rbind(a1, b1, c1, d1, e1, f1, g1, h1, i1, j1)
g1 <- rbind(a1, d1, e1, f1, i1)

#"Kuvaan kategoriat 
# Law, Medicine, History (combined), Theology (combined); 
# jos lisäksi voi olla Philosophy ja vertailun vuoksi Dutch language and literature tai Public and social administration."

###
ss2 <- g1 %>% group_by(publication_year, language_all, cat) %>%
 arrange(publication_year) %>%
 summarize(n = n())
ss2 <- ss2 %>% drop_na(publication_year)
####
top <- rev(rev(sort(table(ss2$language_all)))[1:3])
ss2 <- ss2 %>% filter(language_all %in% names(top))
ss2 <- ss2 %>% filter(publication_year < 1800)
 # labs(title="Leiden subject topics; top-3 language_all") +
p <- ggplot(ss2, aes(x=publication_year, y=n, colour=language_all)) +
 geom_point() +
 stat_smooth(method = 'loess')  +
 labs(color="", x="Publication year", y = "Title count (N)") + 
 facet_wrap(~cat, scales = "free")  +
 theme_comhis("discrete", base_size=20)


CairoJPEG("Figure11.jpg", width=1*500, height=1*500, quality=100)
print(p)
dev.off()