

pics <- townpics[c("Uppsala","Turku")]

# get legend from p1
l <- get_legend(pics[[2]])

# remove legends
for (i in 1:length(pics)) {
  pics[[i]] <- pics[[i]] + theme(legend.position = "none")
}

pics[[2]] <- pics[[2]] + theme(legend.position=c(0.16, 0.85))


p <- pics[["Turku"]] + pics[["Uppsala"]] 

CairoJPEG("Figure6.jpg", width=1*1000, height=1*500, quality=100)
print(p)
dev.off()


s <- 5 * 480; CairoTIFF("Figure6.tif", width=2*s, height=1*s, dpi=300); print(p); dev.off()
