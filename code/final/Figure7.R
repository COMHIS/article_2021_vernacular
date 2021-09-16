pics <- townpics

pics[["Gothenburg"]] <- pics[["Gothenburg"]] + theme(legend.position=c(0.15, 0.85))
pics[["Glasgow"]] <- pics[["Glasgow"]] + theme(legend.position=c(0.30, 0.85))
pics[["Rotterdam"]] <- pics[["Rotterdam"]] + theme(legend.position=c(0.15, 0.85))


p <- pics[["Gothenburg"]] + pics[["Glasgow"]] + pics[["Rotterdam"]] 

CairoJPEG("Figure7.jpg", width=1*1500, height=1*500, quality=100)
print(p)
dev.off()



