# Load data subsets and combine
# - stored in dataset.Rds; use that as the starting point
# source("data.R")

# Analyse
catalogs <- readRDS("../output/dataset.Rds")
rmarkdown::render(input = "place.Rmd",    output_format = "md_document")
rmarkdown::render(input = "language.Rmd", output_format = "md_document")

