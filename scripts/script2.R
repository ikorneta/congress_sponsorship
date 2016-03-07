#setwd("..") #set the directory here

legislators.historic <- read.csv("./data_legislators/legislators-historic.csv")
legislators.current <- read.csv("./data_legislators/legislators-current.csv")

legislators <- unique(rbind(legislators.historic[c(1:8,20)], legislators.current[c(1:8,20)]))
#write.csv(legislators, "./data_legislators/legislators.csv", row.names=FALSE)

congresslist <- c(107:113, "107_108_109_110", "110_111_112_113")

for (congress in congresslist){
  
  house <- read.csv(paste0("./data/", congress, "/congress", congress,"_house_sum.csv"))
  houselist <- unique(c(house$sponsor, house$cosponsors))
  houseleg <- legislators[legislators$thomas_id %in% houselist,]
  housespons <- house[house$sponsor==house$cosponsors,]
  houseleg <- merge(houseleg, housespons[,c(1,3)], by.x="thomas_id", by.y="sponsor", all.x=TRUE)
  colnames(houseleg) <- c(colnames(houseleg[,1:9]), "sponsored")
  houseleg$sponsored <- ifelse(is.na(houseleg$sponsored), 0, houseleg$sponsored)
  
  senate <- read.csv(paste0("./data/", congress, "/congress", congress,"_senate_sum.csv"))
  senatelist <- unique(c(senate$sponsor, senate$cosponsors))
  senateleg <- legislators[legislators$thomas_id %in% senatelist,]
  senatespons <- senate[senate$sponsor==senate$cosponsors,]
  senateleg <- merge(senateleg, senatespons[,c(1,3)], by.x="thomas_id", by.y="sponsor", all.x=TRUE)
  colnames(senateleg) <- c(colnames(senateleg[,1:9]), "sponsored")
  senateleg$sponsored <- ifelse(is.na(senateleg$sponsored), 0, senateleg$sponsored)
  
  write.csv(houseleg, paste0("./data/", congress, "/congress", congress,"_house_leg.csv"), row.names=FALSE, fileEncoding="UTF-8")
  write.csv(senateleg, paste0("./data/", congress, "/congress", congress,"_senate_leg.csv"), row.names=FALSE, fileEncoding="UTF-8")
  
  housenoloop <- house[house$sponsor!=house$cosponsors,]
  senatenoloop <- senate[senate$sponsor!=senate$cosponsors,]
  
  write.csv(housenoloop, paste0("./data/", congress, "/congress", congress,"_house_noloop.csv"), row.names=FALSE)
  write.csv(senatenoloop, paste0("./data/", congress, "/congress", congress,"_senate_noloop.csv"), row.names=FALSE)
  
}