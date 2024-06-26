# Load data subsets and combine
# - stored in dataset.Rds; use that as the starting point
library(bibliographica)
library(tidyverse)
library(comhis)
library(Cairo)

devtools::load_all("bibliographica")

catalogs <- readRDS("../../output/dataset.Rds")

# For STCV use countries from other catalogs
catalogs$stcv$publication_country <- catalogs$estc$publication_country[match(catalogs$stcv$publication_place, catalogs$estc$publication_place)]
catalogs$stcv$publication_country[catalogs$stcv$publication_place %in% c("Brussel", "Leuven", "Gent")] <- "Belgium"
catalogs$stcv$publication_country[catalogs$stcv$publication_place %in% c("Maastricht", "s-Hertogenbosch", "Hague")] <- "Netherlands"

# Selected towns
selected.towns <- as.data.frame(rbind(
  c("Dublin", "estc"),
  c("Edinburgh", "estc"),
  c("Glasgow", "estc"),  
  c("London", "estc"),
  c("Oxford", "estc"),
  c("Cambridge", "estc"),
  c("Stockholm", "snb"),
  c("Lund", "snb"),
  c("Uppsala", "snb"),
  c("Gothenburg", "snb"),  
  c("Turku", "fnb"),
  c("Leiden", "stcn"),
  c("Amsterdam", "stcn"),
  c("The Hague", "stcn"),
  c("Utrecht", "stcn"),
  c("Rotterdam", "stcn"),
  c("Antwerp", "stcv"),
  c("Brussels", "stcv"),
  c("Leuven", "stcv"),	
  c("Gent", "stcv"),
  c("Bruges", "stcv")

))

names(selected.towns) <- c("town", "catalog")

