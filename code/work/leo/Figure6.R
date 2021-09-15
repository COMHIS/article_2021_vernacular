p <- pics[["Uppsala"]] + pics[["Turku"]] 

CairoJPEG("Figure6.jpg", width=1*1000, height=0.8*480, quality=100)
print(p)
dev.off()



