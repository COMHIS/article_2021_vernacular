# Load data subsets and combine
# - stored in dataset.Rds; use that as the starting point
# source("data.R")

# Analyse
catalogs <- readRDS("../output/dataset.Rds")

# Selected towns
selected.towns <- as.data.frame(rbind(
  c("London", "estc"),
  c("Oxford", "estc"),
  c("Cambridge", "estc"),
  c("Stockholm", "snb"),
  c("Lund", "snb"),
  c("Uppsala", "snb"),
  c("Turku", "fnb"),
  c("Leiden", "stcn"),
  c("Amsterdam", "stcn"),
  c("The Hague", "stcn"),
  c("Utrecht", "stcn"),
  c("Rotterdam", "stcn")))
names(selected.towns) <- c("town", "catalog")

rmarkdown::render(input = "place.Rmd",    output_format = "md_document")
rmarkdown::render(input = "language.Rmd", output_format = "md_document")
rmarkdown::render(input = "genre.Rmd", output_format = "md_document")

