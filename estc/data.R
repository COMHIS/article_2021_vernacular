catalog <- "estc";

datalist <- list()

datalist[["language"]]          <- read_language(catalog)                   # Rds
datalist[["geo"]]               <- read.csv("../input/geomapping_process/data_output/estc_geomapped.csv") # From IT
datalist[["publicationyears"]]  <- read_publicationyears(catalog)  # Rds
datalist[["physicalextent"]]    <- read_physicalextent(catalog)    # CSV - known multivol issue
datalist[["physicaldimension"]] <- read_physicaldimension(catalog) # CSV
datalist[["title"]] <- read_title(catalog) # CSV
datalist[["author"]] <- read_author(catalog) # CSV
datalist[["publisher"]] <- read_publisher(catalog) # CSV

# Only taking non-duplicated entries
dat <- combine_tables(datalist) 


