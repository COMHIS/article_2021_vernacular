pics <- townpics



l <- get_legend(pics[["Leiden"]])
# remove legends
for (i in c("Leiden", "Utrecht", "Leuven")) {
  pics[[i]] <- pics[[i]] + theme(legend.position = "none")
}

library(patchwork)
p <- pics[["Leiden"]] + pics[["Utrecht"]] + pics[["Leuven"]] + l

CairoJPEG("Figure5.jpg", width=1.5*500, height=1.5*500, quality=100)
print(p)
dev.off()






