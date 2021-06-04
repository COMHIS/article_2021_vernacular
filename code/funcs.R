read_language <- function (catalog) {

  if (catalog == "estc") {
    x <- read_language_estc(catalog)
  } else if (catalog == "hpb") {
    x <- read_language_hpb()
  } else {
    stop("catalog not recognized in read_language")
  }
  x
}

read_language_hpb <- function () {
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


#########################################################


read_title <- function (catalog) {

  if (catalog == "estc") {
    x <- read_title_estc(catalog)
  } else {
    stop("catalog not recognized in read_title")
  }
  x
}

read_title_estc <- function (catalog) {
  # This is the old initial harmonized data
  file <- "data/estc-cleaned-initial/estc_processed.csv"
  x <- read.csv(file)[, c("system_control_number", "title")]
  x
}


##########################################################

read_author <- function (catalog) {

  if (catalog == "estc") {
    x <- read_author_estc(catalog)
  } else if (catalog == "hpb") {
    x <- read_author_hpb()
  } else {
    stop("catalog not recognized in read_author")
  }
  x
}

##########################################################

read_publicationyears <- function (catalog) {

  if (catalog == "estc") {
    x <- read_publicationyears_estc()
  } else if (catalog == "hpb") {
    x <- read_publicationyears_hpb()
  } else {
    stop("catalog not recognized in read_publicationyears")
  }

  x$original <- NULL
  
  x
}

read_publicationyears_hpb <- function (catalog) {
  field <- "publicationyears"
  folder <- paste0("data/hpb-", field)
  file <- paste(folder, "/", "publicationyears.csv", sep = "")
  x <- read.csv(file, sep = "\t")
  x
}

##########################################################

read_physicalextent <- function (catalog) {

  if (catalog == "estc") {
    x <- read_physicalextent_estc()
  } else if (catalog == "hpb") {
    x <- read_physicalextent_hpb()
  } else {
    stop("catalog not recognized in read_physicalextent")
  }
  x
}

read_physicalextent_hpb <- function (catalog) {
  field <- "physical-extent"
  folder <- paste0("data/hpb-", field)
  file <- paste(folder, "/", "physical_extent.csv.gz", sep = "") 
  x <- read.csv(file, sep = "\t")
  x$system_control_number <- x$ids
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

##########################################################

read_physicaldimension <- function (catalog) {

  if (catalog == "estc") {
    x <- read_physicaldimension_estc()
  } else if (catalog == "hpb") {
    x <- read_physicaldimension_hpb()
  } else {
    stop("catalog not recognized in read_publicationyears")
  }
  x
}

read_physicaldimension_hpb <- function () {
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

##########################################################

read_publicationyears_estc <- function () {
  field <- "publicationyears"
  catalog <- "estc"
  folder <- paste0("data/", catalog, "-", field)
  file <- paste(folder, "/", field, ".csv", sep = "")
  x <- read.csv(file, sep = "\t")
  x
}

##########################################################

read_geoinformation <- function (catalog, file = "allMappedMetadataLocationsBy11.2.2019.csv") {
  field <- "geoinformation"
  folder <- paste0("data/", catalog, "-", field)
  f <- paste(folder, "/", file, sep = "")
  x <- read.csv(f)
  x
}

##########################################################


read_author <- function (catalog) {


  if (catalog == "estc") {
  
    x <- read.csv("data/estc-actors-unified/unified_actorlinks_enriched.csv")
   
    # Add system control number so that it is compatible with the others
    x$system_control_number <- paste0("(CU-RivES)", x$estc_id)
  
    # Only pick author and publisher entries
    author <- subset(x, actor_role_author == "True")
    author <- author[, c("system_control_number", "actor_id", "actor_name_primary")]

    return(author)
    
  } else {
    return(NULL)
  }
  
}


##########################################################

read_publisher <- function (catalog) {

  if (catalog == "estc") {
  
    x <- read.csv("data/estc-actors-unified/unified_actorlinks_enriched.csv")
   
    # Add system control number so that it is compatible with the others
    x$system_control_number <- paste0("(CU-RivES)", x$estc_id)
  
    # Only pick publisher and publisher entries
    publisher <- subset(x, actor_role_publisher == "True")
    publisher <- publisher[, c("system_control_number", "actor_id", "actor_name_primary")]

    return(publisher)
    
  } else {
    return(NULL)
  }
  
}

##########################################################



combine_tables <- function (datalist) {

  # Unique IDs, removing duplicates
  ids0 <- unique(intersect(datalist[[1]]$system_control_number,
    unique(unlist(sapply(datalist, function (x) {unique(x$system_control_number)})))))
  duplicated <- unlist(sapply(datalist, function (x) {
    x$system_control_number[which(duplicated(x$system_control_number))]}))
  
  if (length(unique(duplicated))>0) {
    warning(paste("Removing", length(unique(duplicated)), "duplicate entries in combine_tables."))
  }

  ids <- setdiff(ids0, duplicated)

  dlist <- sapply(datalist, function (d) {d[match(ids, d$system_control_number),]}, USE.NAMES = FALSE)
  
  for (i in 2:length(dlist)) {
    dlist[[i]]$system_control_number <- NULL
  }
  
  names(dlist) <- NULL

  dat <- do.call("cbind", dlist)
  
  dat

}




