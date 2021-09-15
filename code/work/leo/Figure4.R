p <- pics[["Oxford"]] + pics[["Cambridge"]] + pics[["Edinburg"]]

CairoJPEG("Figure4.jpg", width=1*1000, height=1*500, quality=100)
print(p)
dev.off()



