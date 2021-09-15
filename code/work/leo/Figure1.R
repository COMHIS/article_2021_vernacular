# Combine language data from catalogs
df <- NULL
for (ctl in names(catalogs)) {

  tmp <- catalogs[[ctl]][, c("language_primary", "publication_country",
                             "publication_place", "publication_decade", "publication_year")]
  tmp$catalog <- rep(ctl, nrow(tmp))
  df <- dplyr::bind_rows(df, tmp) 
}
df <- df %>% mutate(catalog=toupper(catalog))
df$catalog <- factor(df$catalog)
filter <- dplyr::filter

dfs <- df %>% filter(publication_decade >= 1500) %>%
              filter(publication_decade < 1800) %>%	      
	      group_by(catalog, publication_decade, language_primary) %>%
	      summarise(n=n()) %>%
	      mutate(f=n/sum(n)) %>%
	      filter(language_primary=="Latin") %>%
	      mutate(catalog = toupper(catalog))

# Catalog default colors
cols <- default_colors("catalog")[unique(toupper(dfs$catalog))]
p <- ggplot(dfs, aes(x = publication_decade, y = f,
                     color=catalog, fill=catalog)) +
       #geom_bar(position="dodge", stat="identity") +
       geom_point() +
       geom_line() + 
       theme_comhis("discrete", base_size=20) +
       labs(x = "Publication decade", y = "Latin share (%)") +
       scale_y_continuous(label=scales::percent, limits=c(0,1)) +
       scale_colour_manual(values=unname(cols)) +
       scale_fill_manual(values=unname(cols)) +
       labs(# title="Title share",
            fill="Catalog",
	    color="Catalog") 

CairoJPEG("Figure1.jpg", width=1.2*480, height=0.8*480, quality=100)
print(p)
dev.off()


