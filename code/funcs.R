#' @title Condense Spaces
#' @description Trim and remove double spaces from the input strings.
#' @param x A vector
#' @importFrom stringr str_trim
#' @return A vector with extra spaces removed
#' @details Beginning, double and ending spaces are also removed from the strings.
#' @export 
#' @author Leo Lahti \email{leo.lahti@@iki.fi}
#' @references See citation("bibliographica") 
#' @examples x2 <- condense_spaces(" a  b cd ") # "a b cd"
#' @keywords utilities
condense_spaces <- function (x) {

  x <- str_trim(x, "both")
  x <- gsub(" +", " ", x)
  x[x == ""] <- NA
   
  x

}


#' @title Mark Languages
#' @description Construct binary matrix of languages for each entry
#' @param x language field (a vector)
#' @return data.frame with separate fields for different languages
#' @export
#' @author Leo Lahti \email{leo.lahti@@iki.fi}
#' @examples \dontrun{df <- mark_languages(c("fin;lat","eng"))}
#' @keywords utilities
mark_languages <- function(x, abrv) {

  x0 <- x

  # Harmonize
  x <- tolower(as.character(x))	       
  x[x == "NA"] <- ""
  x[x == "n/a"] <- ""
  x[is.na(x)] <- ""  
  x <- gsub("^;","",x)
  x <- gsub(";$","",x)
  x <- condense_spaces(x)

  # Unique entries only to speed up
  xorig <- x
  xuniq <- unique(xorig)
  x <- xuniq

  # Further harmonization
  x <- gsub("\\(", " ", x)
  x <- gsub("\\)", " ", x)
  x <- gsub("\\,", " ", x)
  x <- gsub(" +", " ", x)
  x <- condense_spaces(x)

  abrv$synonyme <- gsub("\\(", " ", abrv$synonyme)
  abrv$synonyme <- gsub("\\)", " ", abrv$synonyme)
  abrv$synonyme <- gsub("\\,", " ", abrv$synonyme)
  abrv$synonyme <- gsub(" +", " ", abrv$synonyme)  
  abrv <- unique(abrv)

  # Unrecognized languages?
  unrec <- as.vector(na.omit(setdiff(
  	     unique(unlist(strsplit(as.character(unique(x)), ";"))),
	     abrv$synonyme
	     )))

  if (length(unrec) > 0) {
    warning(paste("Unidentified languages (", round(100 * mean(x %in% unrec), 1), "%): ", paste(unrec, collapse = ";"), sep = ""))
  }


  # TODO Vectorize to speed up ?
  for (i in 1:length(x)) {

      lll <- sapply(unlist(strsplit(x[[i]], ";")), function (xx) {
               as.character(map(xx, abrv, remove.unknown = FALSE, mode = "exact.match"))
	       })

      lll <- na.omit(as.character(unname(lll)))
      if (length(lll) == 0) {lll <- NA}
      
      # Just unique languages
      # "Undetermined;English;Latin;Undetermined"
      # -> "Undetermined;English;Latin"
      lll <- unique(lll)
      x[[i]] <- paste(lll, collapse = ";")

  }

  # List all unique languages in the data
  x[x %in% c("NA", "Undetermined", "und")] <- NA
  xu <- na.omit(unique(unname(unlist(strsplit(unique(x), ";")))))

  # Only accept the official / custom abbreviations
  # (more can be added on custom list if needed)
  xu <- intersect(xu, abrv$name)

  len <- sapply(strsplit(x, ";"), length)
  dff <- data.frame(language_count = len)  
  
  multilingual <- len > 1
  dff$multilingual <- multilingual

  # Now check just the unique and accepted ones, and collapse
  # TODO: add ID for those that are not recognized
  # NOTE: the language count and multilingual fields should be fine however
  # as they are defined above already
  x <- sapply(strsplit(x, ";"), function (xi) {paste(unique(intersect(xi, xu)), collapse = ";")})

  dff$languages <- x
  inds <- which(dff$languages == "")
  if (length(inds) > 0) {
    dff$languages[inds] <- "Undetermined"
  }

  # Add primary language
  if (length(grep(";", dff$languages)) > 0) {
    dff$language_primary <- sapply(strsplit(dff$languages, ";"),
                                               function (x) {x[[1]]})
  } else {
    dff$language_primary <- dff$languages
  }

  # Convert to factors
  dff$languages <- as.factor(str_trim(dff$languages))
  dff$language_primary <- as.factor(str_trim(dff$language_primary))
  
  #list(harmonized_full = dff[match(xorig, xuniq),], unrecognized = unrec)
  dff[match(xorig, xuniq),]

}

# -----------------------------------------------

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
  names(x) <- c("language_primary", "system_control_number")
  x <- x[, c(2,1)]
  x$language_latin_primary <-  grepl("Latin", x$language_primary)
  x$language_vernacular_primary <-  grepl("English", x$language_primary)  

  x

}


#########################################################


read_title <- function (catalog, n=30) {

  if (catalog == "estc") {
    x <- read_title_estc(catalog)
  } else {
    stop("catalog not recognized in read_title")
  }

  # Cut title for readability
  if (any(n < nchar(x))) {
    warning(paste(sum(n < nchar(x)), "titles cut to string length", n))
  }
  x$title <- stringr::str_sub(x$title, 1, n)

  x

}

read_title_estc <- function (catalog) {
  # This is the old initial harmonized data
  file <- "data/estc-cleaned-initial/estc_processed.csv"
  x <- read.csv(file)[, c("system_control_number", "title")]
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

read_publicationyears_estc <- function () {
  field <- "publicationyears"
  catalog <- "estc"
  folder <- paste0("data/", catalog, "-", field)
  file <- paste(folder, "/", field, ".csv", sep = "")
  x <- read.csv(file, sep = "\t")
  x <- x[, c("system_control_number", "publication_year", "publication_decade", "publication_century", "uncertain", "circa")]
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
  x <- x[, c("system_control_number", "pagecount", "singlevol", "multivol", "issue")]
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
  x <- x[, c("system_control_number", "gatherings")]
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
    author <- author[, c("system_control_number", "actor_name_primary")]

    # Separate multi author entries by "|"
    vec <- sapply(split(author$actor_name_primary, author$system_control_number), function (x) {paste(x, collapse="|")})
    author <- data.frame(system_control_number = names(vec), authors = unname(vec))

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
    df <- subset(x, actor_role_publisher == "True")[, c("system_control_number", "actor_name_primary")]

    # Separate multi entries by "|"
    vec <- sapply(split(df$actor_name_primary, df$system_control_number), function (x) {paste(x, collapse="|")})
    df <- data.frame(system_control_number = names(vec), publishers = unname(vec))

    return(df)
    
  } else {
    return(NULL)
  }
  
}

##########################################################

read_geo <- function (catalog) {

  if (catalog == "estc") {
    x <- read.csv("../../input/geomapping_process/data_output/estc_geomapped.csv") # From IT
    x <- x[, c("system_control_number", "publication_country", "publication_place")]
    return(x)
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

  # ids first
  idx <- which(names(dat) == "system_control_number")
  dat <- dat[, c(idx, setdiff(1:ncol(dat), idx))]

  # titles last
  idx <- which(names(dat) == "title")
  dat <- dat[, c(setdiff(1:ncol(dat), idx), idx)]

  dat

}




