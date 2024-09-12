pics <- townpics

pics[["London"]] <- pics[["London"]] + theme(legend.position=c(0.14, 0.84))
pics[["Amsterdam"]] <- pics[["Amsterdam"]] + theme(legend.position=c(0.14, 0.84))
pics[["Stockholm"]] <- pics[["Stockholm"]] + theme(legend.position=c(0.14, 0.84))

library(patchwork)
p <- pics[["London"]] + pics[["Amsterdam"]] + pics[["Stockholm"]]


CairoJPEG("Figure3.jpg", width=1*1500, height=1*500, quality=100)
print(p)
dev.off()

s <- 5 * 480; CairoTIFF("Figure3.tif", width=2.7*s, height=0.9*s, dpi=300); print(p); dev.off()


