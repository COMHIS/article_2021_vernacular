catalog <- "hpbd";

datalist <- list()
datalist[["language"]] <- read_language(catalog)
datalist[["publicationyears"]] <- read_publicationyears(catalog)
datalist[["physicalextent"]] <- read_physicalextent(catalog)
datalist[["physicaldimension"]] <- read_physicaldimension(catalog)
datalist[["geo"]] <- read.csv("geomapping_process/data_output/hpb_geomapped.csv")

# Only taking non-duplicated entries
dat <- combine_tables(datalist) 

# Author -> TODO
# Title  -> TODO
# Publication place -> need Iiro's input; hpb-publicationplace


