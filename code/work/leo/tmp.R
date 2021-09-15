

library(ggpubr)
stcn <- catalogs$stcn
top <- rev(rev(sort(table(stcn$language_primary)))[2:2])
bb2 <- stcn %>% filter(language_primary %in% names(top))
bb7 <- bb2[grep("cademic", bb2$genre),]
bb8 <- bb2 %>% filter(!record_id %in% bb7$record_id)
myvars <- as.vector(c("publication_decade", "document_type"))
a1 = bb7[myvars]
b1 = bb8[myvars]
a1$cat <- "Academic"
b1$cat <- "Non-academic"
g1 <- rbind(a1, b1)
#g2 <- g1 %>% group_by(publication_decade, cat, document_type) %>%
g2 <- g1 %>% group_by(publication_decade, cat) %>%
 arrange(publication_decade) %>%
 summarize(n = n())
g2$Category <- factor(g2$cat)
# g2 <- filter(g2, !is.na(document_type))

df <- g2 %>% pivot_wider(names_from=Category, id_cols=c(publication_decade), values_from = n) %>% mutate(Academic=replace_na(Academic, 0)) %>% pivot_longer(cols=c("Academic","Non-academic"))
p <- ggplot(df, aes(x=publication_decade, y=value, fill = name, colour = name)) +
 #geom_point() +
 geom_bar(stat="identity", position="dodge") + 
 labs(title="STCN, Latin") +
 theme_comhis("discrete", base_size=20) +
 theme(legend.position=c(0.15, 0.89)) + 
 labs(x = "Publication decade", y = "Title count (N)", color="", fill="")
print(p)