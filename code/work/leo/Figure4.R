

l <- get_legend(pics[["Oxford"]])
# remove legends
for (i in c("Oxford", "Cambridge", "Edinburgh")) {
  pics[[i]] <- pics[[i]] + theme(legend.position = "none")
}

library(patchwork)
p <- pics[["Oxford"]] + pics[["Cambridge"]] + pics[["Edinburgh"]] + l

CairoJPEG("Figure4.jpg", width=1*1000, height=1*500, quality=100)
print(p)
dev.off()



