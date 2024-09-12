pics <- townpics

pics[["Gothenburg"]] <- pics[["Gothenburg"]] + theme(legend.position=c(0.2, 0.8))
pics[["Glasgow"]] <- pics[["Glasgow"]] + theme(legend.position=c(0.35, 0.8))
pics[["Rotterdam"]] <- pics[["Rotterdam"]] + theme(legend.position=c(0.2, 0.8))


p <- pics[["Gothenburg"]] + pics[["Glasgow"]] + pics[["Rotterdam"]] 

CairoJPEG("Figure7.jpg", width=1*1500, height=1*500, quality=100)
print(p + theme_bw(30))
dev.off()

s <- 5 * 480; CairoTIFF("Figure7.tif", width=2.1*s, height=0.7*s, dpi=300); print(p); dev.off()

