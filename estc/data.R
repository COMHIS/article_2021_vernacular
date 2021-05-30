catalog <- "estc";

datalist <- list()

datalist[["language"]] <- read_language(catalog)                   # Rds
datalist[["publicationyears"]] <- read_publicationyears(catalog)   # Rds
datalist[["physicalextent"]] <- read_physicalextent(catalog)       # CSV
datalist[["physicaldimension"]] <- read_physicaldimension(catalog) # CSV
datalist[["geo"]] <- read.csv("../input/geomapping_process/data_output/estc_geomapped.csv")

# Only taking non-duplicated entries
dat <- combine_tables(datalist) 

# ESTC some available fields
# field <- "actors / viaf / actors-unified / author_data / estc-author-data" # author
# Other:
# - prices
# - publishers
# - publication_frequency


