pics <- townpics

l <- get_legend(pics[["Oxford"]])
# remove legends
for (i in c("Oxford", "Cambridge", "Edinburgh")) {
  pics[[i]] <- pics[[i]] + theme(legend.position = "none")
}

library(patchwork)
p <- pics[["Oxford"]] + pics[["Cambridge"]] + pics[["Edinburgh"]] + l

CairoJPEG("Figure4.jpg", width=1.5*500, height=1.5*500, quality=100)
print(p)
dev.off()

s <- 5 * 480; CairoTIFF("Figure4.tif", width=1.5*s, height=1.5*s, dpi=300); print(p); dev.off()


