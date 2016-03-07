#setwd("..") #set the directory here

library(jsonlite)
library(plyr)

#congress_list <- system2("ls", args="./data_bills", stdout=TRUE)

congresslist <- c(107:113, "107_108_109_110", "110_111_112_113")

for (congress in congress_list)
{
  print(congress)
 bill_type_list <- system2("ls", args=paste0("./data_bills/",congress,"/bills"), stdout=TRUE)
 
 #separate list for each Congress
 
 for (bill_type in bill_type_list)
 {
   print(bill_type)
  bill_list <- system2("ls", args=paste0("./data_bills/",congress,"/bills/",bill_type), stdout=TRUE)
  nodelist <- data.frame(sponsor=character(), cosponsor=character()) 
  
  
  for (bill in bill_list)
  {
   filename <- paste0("./data_bills/",congress,"/bills/",bill_type,"/",bill,"/data.json")
   con <- file(filename, "r")
   billdata <- fromJSON(readLines(con))
   close(con)
   
   sponsor <- billdata$sponsor$thomas_id
   cosponsors <- billdata$sponsor$thomas_id
   if (length(billdata$cosponsors)>0)
   {
     cosponsors <- c(cosponsors,billdata$cosponsors$thomas_id)
   }
   nodelist <- rbind(nodelist,cbind(sponsor,cosponsors))  
  }
  
  nam <- paste0(bill_type)
  assign(nam, nodelist)
  
 }
}

if (!("data" %in% system2("ls", stdout=TRUE)))
{
  system2("mkdir", args="./data")       
}

system2("mkdir", args=paste0("./data/", congress))

house <- rbind(hconres, hjres, hr, hres)
write.csv(house, paste0("./data/", congress,"./congress", congress,"_house.csv"), row.names=FALSE)
house <- read.csv(paste0("./data/", congress,"./congress", congress,"_house.csv"), strip.white=FALSE, colClasses=c("character", "character"))
house2 <- ddply(house,.(sponsor,cosponsors),nrow)
write.csv(house2, paste0("./data/", congress,"./congress", congress,"_house_sum.csv"), row.names=FALSE)

senate <- rbind(sconres, sjres, s, sres)
write.csv(senate, paste0("./data/", congress,"./congress", congress,"_senate.csv"), row.names=FALSE)
senate <- read.csv(paste0("./data/", congress,"./congress", congress,"_senate.csv"), strip.white=FALSE, colClasses=c("character", "character"))
senate2 <- ddply(senate,.(sponsor,cosponsors),nrow)
write.csv(senate2, paste0("./data/", congress,"./congress", congress,"_senate_sum.csv"), row.names=FALSE)