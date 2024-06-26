# Load data subsets and combine
# - stored in dataset.Rds; use that as the starting point
library(bibliographica)
library(tidyverse)
devtools::load_all("~/comhis/rpkg/bibliographica/")

catalogs <- readRDS("../../../output/dataset.Rds")

# For STCV use countries from other catalogs
catalogs$stcv$publication_country <- catalogs$estc$publication_country[match(catalogs$stcv$publication_place, catalogs$estc$publication_place)]
catalogs$stcv$publication_country[catalogs$stcv$publication_place %in% c("Brussel", "Leuven", "Gent")] <- "Belgium"
catalogs$stcv$publication_country[catalogs$stcv$publication_place %in% c("Maastricht", "s-Hertogenbosch", "Hague")] <- "Netherlands"

# Selected towns
selected.towns <- as.data.frame(rbind(
  c("Dublin", "estc"),
  c("Edinburgh", "estc"),
  c("Glasgow", "estc"),  
  c("London", "estc"),
  c("Oxford", "estc"),
  c("Cambridge", "estc"),
  c("Stockholm", "snb"),
  c("Lund", "snb"),
  c("Uppsala", "snb"),
  c("Gothenburg", "snb"),  
  c("Turku", "fnb"),
  c("Leiden", "stcn"),
  c("Amsterdam", "stcn"),
  c("The Hague", "stcn"),
  c("Utrecht", "stcn"),
  c("Rotterdam", "stcn"),
  c("Antwerp", "stcv"),
  c("Brussels", "stcv"),
  c("Leuven", "stcv"),	
  c("Gent", "stcv"),
  c("Bruges", "stcv")

))

names(selected.towns) <- c("town", "catalog")

rmarkdown::render(input = "place.Rmd",    output_format = "md_document")
rmarkdown::render(input = "language.Rmd", output_format = "md_document")
rmarkdown::render(input = "genre.Rmd", output_format = "md_document")
rmarkdown::render(input = "stcn.Rmd", output_format = "md_document")
rmarkdown::render(input = "estc.Rmd", output_format = "md_document")


# Final figures
#rmarkdown::render(input = "final.Rmd", output_format = "pdf_document")
source("figures_final.R")



# Check undetermined language in primary lang field
tab <- catalogs$snb %>% filter(grepl("Undetermined", language_primary)) %>% select("author", "publication_year", "title", "subject_topic")
write.table(tab, file = "snb_und_lang.csv", quote=F, row.names=F, sep="\t")



