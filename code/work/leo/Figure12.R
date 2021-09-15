mylang <- c("French")

dat <- NULL
for (catalog in setdiff(names(catalogs), c("fnb", "stcv"))) {

  df <- catalogs[[catalog]]
  df$language_primary <- as.character(df$language_primary)
  dfs <- df %>% mutate(language_primary = factor(replace(language_primary,
                       !language_primary %in% mylang, "Other"))) %>%
              filter(publication_decade >= 1600) %>%
              filter(publication_decade < 1800) %>%
	      group_by(publication_decade, language_primary) %>%
	      summarise(n=n()) %>%
	      mutate(f=n/sum(n)) %>%
              filter(language_primary %in% mylang) 

  dfss <- dfs %>% filter(language_primary %in% mylang)
  dfss$catalog <- rep(catalog, nrow(dfss))
  dat <- bind_rows(dat, dfss)
 

}
dat$catalog <- factor(toupper(dat$catalog))

cols <- default_colors("catalog")[levels(dat$catalog)]
p <- ggplot(dat, aes(x = publication_decade, y = n,
            color=catalog, fill=catalog)) +
       geom_bar(stat="identity", position="dodge") +
       theme_comhis("discrete", base_size=20) +
       labs(x = "Publication decade", y = "Title count (n)") +              
       labs(title="Title count",
            subtitle=mylang,
            color="Catalog",
	    fill="Catalog") 
	    

CairoJPEG("Figure12.jpg", width=1*500, height=1*500, quality=100)
print(p)
dev.off()