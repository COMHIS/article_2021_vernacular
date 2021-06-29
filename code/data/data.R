catalogs <- list()
catalogs[["estc"]] <- readRDS("../estc/estc_subset.rds")
catalogs[["snb"]] <- readRDS("../snb/snb_subset.rds")
catalogs[["fnb"]] <- readRDS("../fnb/fnb_subset.rds")
catalogs[["stcn"]] <- readRDS("../stcn/stcn_subset.rds")
# catalogs[["hpb"]] <- readRDS("../hpb/hpb_subset.rds") # Excluded

saveRDS(catalogs, file = "../../output/dataset.Rds")
