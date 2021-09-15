catalogs <- list()
catalogs[["estc"]] <- readRDS("../estc/estc_subset.rds")
catalogs[["snb"]] <- readRDS("../snb/snb_subset.rds")
catalogs[["fnb"]] <- readRDS("../fnb/fnb_subset.rds")
catalogs[["stcn"]] <- readRDS("../stcn/stcn_subset.rds")
catalogs[["stcv"]] <- readRDS("../stcv/stcv_subset.rds")
# catalogs[["hpb"]] <- readRDS("../hpb/hpb_subset.rds") # Excluded

# Limit years to 1830
catalogs <- lapply(catalogs, function (x) {subset(x, publication_year < 1830)})

# Except for ESTC/STCN/STCV
catalogs$estc <- subset(catalogs$estc, publication_year < 1800)
catalogs$stcn <- subset(catalogs$stcn, publication_year < 1800)
catalogs$stcv <- subset(catalogs$stcv, publication_year < 1800)

saveRDS(catalogs, file = "../../output/dataset.Rds")
