catalog <- "hpbd";

dat <- list()

dat[["language"]] <- read_language(catalog)
dat[["publicationyears"]] <- read_publicationyears(catalog)
dat[["physicalextent"]] <- read_physicalextent(catalog)
dat[["physicaldimension"]] <- read_physicaldimension(catalog)

# Author -> TODO
# Title  -> TODO
# Publication place -> need Iiro's input; hpb-publicationplace


