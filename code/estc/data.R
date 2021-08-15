
datalist <- list()
datalist[["language"]]          <- read_language(catalog)          # Rds
datalist[["geo"]]               <- read_geo(catalog)
datalist[["publicationyears"]]  <- read_publicationyears(catalog)  # Rds
datalist[["physicalextent"]]    <- read_physicalextent(catalog)    # CSV - known multivol issue
datalist[["physicaldimension"]] <- read_physicaldimension(catalog) # CSV
datalist[["title"]]             <- read_title(catalog, n = Inf) # CSV; cut at 30 chars
datalist[["author"]]            <- read_author(catalog) # CSV
datalist[["publisher"]]         <- read_publisher(catalog) # CSV

# Only taking non-duplicated entries
dat <- combine_tables(datalist) 


# Add work field from /article_2019_early_modern_canon_data_private/
works <- read.csv("works_places.csv")
works$system_control_number <- stringr::str_remove(works$system_control_number, "\\(CU-RivES\\)")
# First match
dat$finalWorkField <- works[match(dat$system_control_number, works$system_control_number), "finalWorkField"]


