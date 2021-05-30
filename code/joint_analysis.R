# Load data subsets
source("data.R")

# Analyse
rmarkdown::render(input = "place.Rmd",    output_format = "md_document")
rmarkdown::render(input = "language.Rmd", output_format = "md_document")

