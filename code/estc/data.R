datalist <- list()
datalist[["language"]]          <- read_language(catalog)          # Rds
datalist[["geo"]]               <- read_geo(catalog)
datalist[["publicationyears"]]  <- read_publicationyears(catalog)  # Rds
datalist[["physicalextent"]]    <- read_physicalextent(catalog)    # CSV - known multivol issue
datalist[["physicaldimension"]] <- read_physicaldimension(catalog) # CSV
datalist[["title"]]             <- read_title(catalog, n = 30) # CSV; cut at 30 chars
datalist[["author"]]            <- read_author(catalog) # CSV
datalist[["publisher"]]         <- read_publisher(catalog) # CSV

# Only taking non-duplicated entries
dat <- combine_tables(datalist) 

