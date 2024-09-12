## first the latin set add subject topic info

bb1 <- stcn[grep("Latin", stcn$language_all),]

bb1$genre <- x$genre[match(bb1$record_id, x$record_id)]

bb2 <- bb1[grep("cademic", bb1$genre),]

bb3 <- bb2 %>% group_by(publication_place, publication_year) %>%
  arrange(genre) %>%
  summarize(n = n())

bb3 <- bb3 %>% drop_na(publication_year)

write.csv(bb3, file = 'latin_academic_texts.csv', row.names = FALSE)

####

top <- rev(rev(sort(table(bb3$publication_place)))[1:5])

bb3 <- bb3 %>% filter(publication_place %in% names(top))

ggplot(bb3, aes(x=publication_year, y=n, group=publication_place, colour=publication_place)) +
  geom_point() +
  stat_smooth(method = 'loess')   + theme_classic() + grids(linetype = "dashed") +
  labs(title="academic text in genre; top5 places") + theme(axis.text.x = element_text(angle = 90, size = 11))

+
  scale_x_discrete(breaks = seq(from = 1500, to = 1800, by = 50))

+
  facet_wrap(~publication_place, scales = "free") 

###


df2 <- stcn %>% filter(publication_place == "Rotterdam")
