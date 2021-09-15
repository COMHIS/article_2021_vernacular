p <- pics[["Gothenburg"]] + pics[["Glasgow"]] + pics[["Rotterdam"]] 

CairoJPEG("Figure7.jpg", width=1*1500, height=0.8*480, quality=100)
print(p)
dev.off()



