catalog <- "estc";

dat <- list()

dat[["language"]] <- read_language(catalog)                   # Rds
dat[["publicationyears"]] <- read_publicationyears(catalog)   # Rds
dat[["physicalextent"]] <- read_physicalextent(catalog)       # CSV
dat[["physicaldimension"]] <- read_physicaldimension(catalog) # CSV 

# Unique IDs, removing duplicates
ids <- unique(intersect(dat[[1]]$system_control_number, unique(unlist(sapply(dat, function (x) {unique(x$system_control_number)})))))
duplicated <- unlist(sapply(dat, function (x) {x$system_control_number[which(duplicated(x$system_control_number))]}))
ids <- setdiff(ids, duplicated)

dlist <- sapply(dat, function (d) {d[match(ids, d$system_control_number),]}, USE.NAMES = FALSE)
for (i in 2:length(dlist)) {dlist[[i]]$system_control_number <- NULL}
names(dlist) <- NULL
dd <- do.call("cbind", dlist)



# ESTC
# field <- "actors / viaf / actors-unified / author_data / estc-author-data" # author
# Other:
# - prices
# - publishers
# - publication_frequency


