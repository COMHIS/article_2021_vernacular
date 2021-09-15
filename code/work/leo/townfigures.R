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


# For each place, show top languagues
library(dplyr)
ntop <- 3
pics <- list()
cols <- default_colors("language")
for (i in seq_len(nrow(selected.towns))) {

  ctl <- toupper(selected.towns[i, "catalog"])
  town <- selected.towns[i, "town"]

  # Pick the selected town and catalog
  dfs <- df %>% filter(publication_place == town & catalog == ctl) %>%
                filter(publication_year <= 1800)

  # Top languages for this catalog and place
  dfs$language_primary <- compress_field(dfs$language_primary, topn = ntop, rest = "Other")

  # Group by decade
  dfs <- dfs %>% group_by(publication_year, publication_place, language_primary) %>%
                 summarise(n = n()) %>%
		 mutate(f = n/sum(n)) %>%
		 group_by(publication_year, publication_place) %>%
		 arrange(desc(n)) %>%
		 mutate(rank = rev(rank(n))) %>%
		 filter(rank <= ntop)

   # Arrange levels by rank
   dfs$language_primary <- droplevels(factor(dfs$language_primary))

   # Replace NA with 0
   dfs$n[is.na(dfs$n)] <- 0

   v <- seq(min(na.omit(df$publication_decade)), 1800, 50)
   mycols <- cols[as.character(levels(dfs$language_primary))]
   if (any(is.na(mycols))) {stop(paste("Define color for ", setdiff(as.character(dfs$language_primary), names(cols))))}
   p <- ggplot(dfs, aes(x = publication_year, y = n)) +
         geom_point(aes(color = language_primary,
	                fill = language_primary)) +
         geom_smooth(aes(fill = language_primary,
	        	 color = language_primary)) +
         scale_x_continuous(breaks = v, labels = v) +
         labs(title = town,
	      subtitle = ctl,
	      y = "Title count (n)",
	      x = "Publication year",
	      color = ""
	      ) +
	 guides(fill="none", position = "") +
         theme_comhis("discrete", base_size=20) +
	 scale_color_manual(values = mycols) +
	 scale_fill_manual(values = mycols) 	 
  pics[[selected.towns[i,"town"]]] <- p	 

}