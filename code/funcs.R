read_author <- function (catalog) {

  if (catalog == "estc") {
    x <- read_author_estc(catalog)
  } else if (catalog == "hpbd") {
    x <- read_author_hpbd()
  } else {
    stop("catalog not recognized in read_language")
  }
  x
}

read_language <- function (catalog) {

  if (catalog == "estc") {
    x <- read_language_estc(catalog)
  } else if (catalog == "hpbd") {
    x <- read_language_hpbd()
  } else {
    stop("catalog not recognized in read_language")
  }
  x
}

read_publicationyears <- function (catalog) {

  if (catalog == "estc") {
    x <- read_publicationyears_estc()
  } else if (catalog == "hpbd") {
    x <- read_publicationyears_hpbd()
  } else {
    stop("catalog not recognized in read_publicationyears")
  }
  x
}

read_physicalextent <- function (catalog) {

  if (catalog == "estc") {
    x <- read_physicalextent_estc()
  } else if (catalog == "hpbd") {
    x <- read_physicalextent_hpbd()
  } else {
    stop("catalog not recognized in read_publicationyears")
  }
  x
}

read_physicaldimension <- function (catalog) {

  if (catalog == "estc") {
    x <- read_physicaldimension_estc()
  } else if (catalog == "hpbd") {
    x <- read_physicaldimension_hpbd()
  } else {
    stop("catalog not recognized in read_publicationyears")
  }
  x
}

read_publicationyears_hpbd <- function (catalog) {
  field <- "publicationyears"
  folder <- paste0("data/hpb-", field)
  file <- paste(folder, "/", "publicationyears.csv", sep = "")
  x <- read.csv(file, sep = "\t")
  x
}


read_physicalextent_hpbd <- function (catalog) {
  field <- "physical-extent"
  folder <- paste0("data/hpb-", field)
  file <- paste(folder, "/", "physical_extent.Rds", sep = "")
  x <- readRDS(file)
  x
}

read_physicalextent_estc <- function () {
  field <- "physicalextent"
  catalog <- "estc"
  folder <- paste0("data/", catalog, "-", field)    
  file <- paste(folder, "/", "physicalextent.csv", sep = "")
  x <- read.csv(file, sep = "\t")
  x
}


read_physicaldimension_hpbd <- function () {
  field <- "physicaldimension"
  catalog <- "hpb"  
  folder <- paste0("data/", catalog, "-", field)
  file <- paste(folder, "/", "physical_dimension.csv", sep = "")
  x <- read.csv(file, sep = "\t")    
  x
}


read_physicaldimension_estc <- function () {
  field <- "physicaldimension"
  catalog <- "estc"
  folder <- paste0("data/", catalog, "-", field)
  file <- paste(folder, "/", "physical_dimension.csv", sep = "")
  x <- read.csv(file, sep = "\t")  
  x
}



read_language_hpbd <- function () {
  field <- "language"
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




read_publicationyears_estc <- function () {
  field <- "publicationyears"
  catalog <- "estc"
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


combine_tables <- function (datalist) {

  # Unique IDs, removing duplicates
  ids <- unique(intersect(datalist[[1]]$system_control_number, unique(unlist(sapply(datalist, function (x) {unique(x$system_control_number)})))))
  duplicated <- unlist(sapply(datalist, function (x) {x$system_control_number[which(duplicated(x$system_control_number))]}))
  ids <- setdiff(ids, duplicated)

  dlist <- sapply(datalist, function (d) {d[match(ids, d$system_control_number),]}, USE.NAMES = FALSE)
  for (i in 2:length(dlist)) {dlist[[i]]$system_control_number <- NULL}
  names(dlist) <- NULL

  dat <- do.call("cbind", dlist)
  dat

}




