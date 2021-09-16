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
myvars <- as.vector(c("publication_decade", "language_all"))
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

b1$cat <- "Theology"
#c1$cat <- "public and social administration"

d1$cat <- "History"
e1$cat <- "Medicine"

#f1$cat <- "Dutch language and literature"
#g1$cat <- "french language and literature"
#h1$cat <- "latin language and literature"
i1$cat <- "Philosophy"
j1$cat <- "Poetry"
#g1 <- rbind(a1, b1, c1, d1, e1, f1, g1, h1, i1, j1)
g1 <- rbind(a1, b1, d1, e1, j1, i1)

#"Kuvaan kategoriat 
# Law, Medicine, History (combined), Theology (combined); 
# jos lisäksi voi olla Philosophy ja vertailun vuoksi Dutch language and literature tai Public and social administration."

###
ss2 <- g1 %>% group_by(publication_decade, language_all, cat) %>%
 arrange(publication_decade) %>%
 summarize(n = n()) %>%
 drop_na(publication_decade) 

####
top <- rev(rev(sort(table(ss2$language_all)))[1:3])
ss2 <- ss2 %>%
               filter(language_all %in% names(top)) %>%
               filter(publication_decade < 1800) %>%
	       filter(!is.na(language_all)) %>%
	       mutate(language_all=droplevels(language_all))
	       
# labs(title="Leiden subject topics; top-3 language_all") +
cols <- default_colors("language")
pics <- list()


df <- ss2 %>% pivot_wider(names_from=cat, id_cols=c(publication_decade, language_all), values_from = n)
df[is.na(df)] <- 0
df <- df %>% pivot_longer(names(df)[3:7])


for (cate in unique(df$name)) {
  dfs <- subset(df, name==cate)
  mycols <- cols[as.character(levels(dfs$language_all))]
  pics[[cate]] <- ggplot(dfs, aes(x=publication_decade, y=value, fill=language_all, color=language_all)) +
         geom_point() +
	 geom_line() + 	 
 	 labs(color="", x="Publication decade", y = "Title count (N)", fill="", title=cate) + 
 	 theme_comhis("discrete", base_size=20) +
	 scale_color_manual(values = mycols) +
	 scale_fill_manual(values = mycols) 
}


# get legend from p1
l <- get_legend(pics[[1]])

# remove legends
for (i in 1:length(pics)) {
  pics[[i]] <- pics[[i]] + theme(legend.position = "none")
}

library(patchwork)
p <- pics[[1]] + pics[[2]] + pics[[3]] + pics[[4]] + pics[[5]] + l

CairoJPEG("Figure11.jpg", width=1.9*500, height=1*500, quality=100)
print(p)
dev.off()
