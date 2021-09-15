# Top genres, excludeing Period documents, Poetry, and State publications.
# Share of vernacular languages across all documents


df0 <- df <- catalogs[["stcn"]]

# Most common genres out of all separate ones
spl <- stringr::str_split(df$genre, "\\|")
top.genres <- names(which(rev(sort(table(unlist(spl)))) > 500))[1:10]

top.genres <- setdiff(top.genres, c("Period documents", "Poetry", "State publications"))

  dfw <- df0
  spl <- stringr::str_split(dfw$genre, "\\|")

  dflong <- NULL
  
for (sel.genre in top.genres) {

    dfw$hit <- sapply(spl, function (x){sel.genre %in% x})
    
    dfl <- dfw %>% filter(hit) %>%
               filter(language_primary %in% c("Latin", "Dutch")) %>%
       	       group_by(publication_decade, language_primary) %>%	       
	       tally() %>%
	       select(publication_decade, language_primary, n) %>%
               tidyr::pivot_wider(names_from = language_primary, values_from = n, values_fill=0)
    
     dfl$genre <- rep(sel.genre, rep = nrow(dfl))

     if (!"Latin" %in% names(dfl)) {
       dfl$Latin <- rep(0, nrow(dfl))
     }
     if (!"Dutch" %in% names(dfl)) {
       dfl$Dutch <- rep(0, nrow(dfl))
     }

     dfl <- dfl %>%
	       mutate(Both = Latin + Dutch) %>%
	       mutate(Vernacular_Freq = Dutch / Both)

     dflong <- bind_rows(dflong, dfl)

}

dflong$genre <- factor(dflong$genre)

p <- ggplot(dflong, aes(x = publication_decade,
       		      	  color=genre,
			  fill=genre,
                          y = Vernacular_Freq)) +
       #geom_line()  +
       geom_point() +
       geom_smooth() + 
       #labs(#title="Vernacular share",
       #     #subtitle="All documents") +
       theme_comhis("discrete", base_size=20) +
       labs(x = "Publication decade", y = "Share (%)",
            color="Genre", fill="Genre") +
       scale_y_continuous(label=scales::percent, limits=c(0,1))
       


CairoJPEG("Figure8.jpg", width=1*1500, height=1*500, quality=100)
print(p)
dev.off()
