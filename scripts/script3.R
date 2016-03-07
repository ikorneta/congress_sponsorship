#setwd("..") #set the directory here

library(igraph)

congresslist <- c(107:113, "107_108_109_110", "110_111_112_113")
chamber <- c("house", "senate")

for (congress in congresslist){
  if (nchar(congress)<4) {cutoff <- c(5,10)} else {cutoff <- c(5,10,20,30,40)}
  
  for (x in chamber)
  {
    for (y in cutoff){
      nodes <- read.csv(paste0("./data/", congress, "/congress", congress,"_", x,"_leg.csv"), fileEncoding="UTF-8")
      edges <- read.csv(paste0("./data/", congress, "/congress", congress,"_", x,"_noloop.csv"))
      
      edges_large <- edges[edges$V1>y,]
      nodes_large <- nodes[nodes$thomas_id %in% unique(c(edges_large$sponsor, edges_large$cosponsors)),]
      nodes_large <- cbind(nodes_large$thomas_id, nodes_large)
      edges_large <- merge(edges_large, nodes_large[,c(2,10)], by.x="sponsor", by.y="thomas_id")
      colnames(edges_large) <- c("sponsor", "cosponsors", "weight", "sponsor_party")
      
      g <- graph_from_data_frame(edges_large, directed=TRUE, vertices=nodes_large)
      
      if (length(levels(nodes_large$party))>2){
        vertexcolormap <- c("blue", rep("orange", length(levels(nodes_large$party))-2), "red")
        edgecolormap <- c("#3182bd", rep("#fec44f", length(levels(nodes_large$party))-2), "#de2d26")}
      if (length(levels(nodes_large$party))==2){
        vertexcolormap <- c("blue", "red")
        edgecolormap <- c("#3182bd", "#de2d26")}
      
      
      vertexsizemap <- round(sqrt(nodes_large$sponsored+1))
      edgewidthmap <- round(sqrt(edges_large$weight))
      
      if (!("graphs" %in% system2("ls", stdout=TRUE)))
      {
        system2("mkdir", args="./graphs")       
      }
                
      
      png(filename=paste0("./graphs/", congress,"_", x, "_", y, ".png"), width=1200, height=769)
      
      plot <- plot(g, vertex.color=vertexcolormap[nodes_large$party], vertex.size=vertexsizemap, 
                   vertex.label=as.character(nodes_large$last_name), vertex.label.family="mono", 
                   vertex.label.cex=0.8, vertex.label.dist=0.4, vertex.label.color="black", vertex.label.font=2,
                   edge.color=edgecolormap[edges_large$sponsor_party],
                   edge.width=edgewidthmap, edge.arrow.size=0.2, edge.arrow.width=0.7,
                   edge.label=as.character(edges_large$weight), edge.label.family="mono",
                   edge.label.cex=0.6, edge.label.color="black")
      
      dev.off()
      
      if(y==5)
        {
      flist <- merge(edges_large, nodes_large[,c(2, 3, 10)], by.x="cosponsors", by.y="thomas_id")
      flist <- merge(flist, nodes_large[,c(2,3,10)], by.x="sponsor", by.y="thomas_id")
      flist <- flist[,c(1,7,8,2,5,6,3)]
      colnames(flist) <- c("sponsor.thomasid", "sponsor.name", "sponsor.party", "cosponsor.thomasid", "cosponsor.name", "cosponsor.party", "edge.weight")
      write.csv(flist, paste0("./data/", congress, "/congress", congress,"_", x,"_zzzedgelist.csv"), row.names=FALSE, fileEncoding="UTF-8")
      }
    }  
  }
}

