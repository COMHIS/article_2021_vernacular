catalog <- "hpbd";

dat <- list()
field <- "language"
x <- read_language("estc")
dat[[field]] <- x


# ESTC
# field <- "publicationyears"
# field <- "physicalextent" # Page numbers
# field <- "physicaldimension" # Book format
# field <- "actors / viaf / actors-unified" # author
# field <- "" # title
# Other: prices / publishers / publication_frequency

