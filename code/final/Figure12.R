

CairoJPEG("Figure12.jpg", width=1.3*500, height=1*500, quality=100)
print(townpics[["The Hague"]] + theme(legend.position=c(0.1, 0.85)))
dev.off()

s <- 5 * 480; CairoTIFF("Figure12.tif", width=1.3*s, height=1*s, dpi=300); print(townpics[["The Hague"]] + theme(legend.position=c(0.1, 0.85))); dev.off()



