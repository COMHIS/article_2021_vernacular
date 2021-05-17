read_language <- function (catalog) {

  if (catalog == "estc") {
    x <- read_language_estc(catalog)
  } else if (catalog == "hpbd") {
    x <- read_language_hpbd()
  } else {
    stop("catalog not recognized in read_language")
  }

}

read_language_hpbd <- function () {
  folder <- paste0("data/hpb-", field)
  file <- paste(folder, "/", "language_008.Rds", sep = "")
  x <- readRDS(file)
  x
}

read_language_estc <- function (catalog) {
  field <- "language"
  folder <- paste0("data/", catalog, "-", field)
  file <- paste(folder, "/", field, ".csv", sep = "")
  x <- read.csv(file, sep = "\t")
  x
}



read_geoinformation <- function (catalog, file = "allMappedMetadataLocationsBy11.2.2019.csv") {
  field <- "geoinformation"
  folder <- paste0("data/", catalog, "-", field)
  f <- paste(folder, "/", file, sep = "")
  x <- read.csv(f)
  x
}




