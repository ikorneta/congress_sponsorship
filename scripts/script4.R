#setwd("..") #set the directory here
library(plyr)

congresses <- c("110", "111", "112", "113")
chambers <- c("house", "senate")

system2("mkdir", args=paste0("./data/", paste0(congresses, collapse="_")))
for (chamber in chambers)
{
  start <- data.frame(sponsor=character(), cosponsors=character())
  
  for (congress in congresses)
  {
    temp <- read.csv(paste0("./data/", congress,"./congress", congress,"_",chamber,".csv"), strip.white=FALSE, colClasses=c("character", "character"))  
    start <- rbind(start,temp)
  }  
  start2 <- ddply(start,.(sponsor,cosponsors),nrow)
  write.csv(start2, paste0("./data/", paste0(congresses, collapse="_"),"/congress", paste0(congresses, collapse="_"),"_",chamber,"_sum.csv"), row.names=FALSE)
}