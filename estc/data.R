catalog <- "estc";

datalist <- list()

datalist[["language"]] <- read_language(catalog)                   # Rds
datalist[["publicationyears"]] <- read_publicationyears(catalog)   # Rds
datalist[["physicalextent"]] <- read_physicalextent(catalog)       # CSV
datalist[["physicaldimension"]] <- read_physicaldimension(catalog) # CSV 

# Unique IDs, removing duplicates
ids <- unique(intersect(datalist[[1]]$system_control_number, unique(unlist(sapply(datalist, function (x) {unique(x$system_control_number)})))))
duplicated <- unlist(sapply(datalist, function (x) {x$system_control_number[which(duplicated(x$system_control_number))]}))
ids <- setdiff(ids, duplicated)

dlist <- sapply(datalist, function (d) {d[match(ids, d$system_control_number),]}, USE.NAMES = FALSE)
for (i in 2:length(dlist)) {dlist[[i]]$system_control_number <- NULL}
names(dlist) <- NULL

dat <- do.call("cbind", dlist)



# ESTC
# field <- "actors / viaf / actors-unified / author_data / estc-author-data" # author
# Other:
# - prices
# - publishers
# - publication_frequency


