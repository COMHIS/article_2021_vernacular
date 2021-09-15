p <- pics[["Leiden"]] + pics[["Utrecht"]] + pics[["Leuven"]]

CairoJPEG("Figure5.jpg", width=1*1500, height=0.8*480, quality=100)
print(p)
dev.off()



