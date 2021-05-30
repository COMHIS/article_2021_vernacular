catalog <- "hpb";

datalist <- list()
datalist[["language"]] <- read_language(catalog)
datalist[["publicationyears"]] <- read_publicationyears(catalog)
datalist[["physicalextent"]] <- read_physicalextent(catalog)
datalist[["physicaldimension"]] <- read_physicaldimension(catalog)
datalist[["geo"]] <- read.csv("../input/geomapping_process/data_output/hpb_geomapped.csv")

# Unify entry names (remove field specific prefixes)
for (nam in names(datalist)) {
  print(nam)
  datalist[[nam]]$system_control_number <- stringr::str_split_fixed(datalist[[nam]]$system_control_number, ":", 2)[,2]
}

# Only taking non-duplicated entries
dat <- combine_tables(datalist) 




