
library(cowplot)
p <- pics[["London"]] + pics[["Amsterdam"]] + pics[["Stockholm"]]


CairoJPEG("Figure3.jpg", width=1*1500, height=0.8*480, quality=100)
print(p)
dev.off()



