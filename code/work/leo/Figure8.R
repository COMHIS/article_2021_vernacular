# Top 8 genres after excluding Period documents, Poetry, and State publications.
# and combining all Theology (*), and all History (*)
# Share of vernacular languages across all documents


dfw <- catalogs[["stcn"]]
dfw$genre <- str_replace_all(dfw$genre, "Theology \\(.*\\)", "Theology")
dfw$genre <- str_replace_all(dfw$genre, "History \\(.*\\)", "History")

# Most common genres out of all separate ones
spl <- stringr::str_split(dfw$genre, "\\|")

top.genres <- names(rev(sort(table(unlist(spl)))))[1:(8+3)]
top.genres <- setdiff(top.genres, c("Period documents", "Poetry", "State publications", "Holland", "Dutch language and literature"))

dflong <- NULL
  
for (sel.genre in top.genres) {

    dfw$hit <- sapply(spl, function (x){sel.genre %in% x})
    
    dfl <- dfw %>% filter(hit) %>%
               filter(language_primary %in% c("Latin", "Dutch")) %>%
       	       group_by(publication_year, language_primary) %>%	       
	       tally() %>%
	       select(publication_year, language_primary, n) %>%
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

p <- ggplot(dflong, aes(x = publication_year,
       		      	  color=genre,
			  fill=genre,
                          y = Vernacular_Freq)) +
       geom_point() +
       #geom_smooth(span=0.8, se=FALSE) +
       geom_smooth(se=FALSE) +        
       theme_comhis("discrete", base_size=20) +
       labs(x = "Publication year", y = "Share (%)",
            color="Genre", fill="Genre") +
       scale_y_continuous(label=scales::percent, limits=c(0,1))
       


CairoJPEG("Figure8.jpg", width=1*1200, height=1*500, quality=100)
print(p)
dev.off()
