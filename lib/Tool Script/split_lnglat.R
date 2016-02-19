#split long lat
mta <- read.csv("/Users/yiliu/Desktop/DOITT_SUBWAY_ENTRANCE_01_13SEPT2010.csv")
mta <- mta[c(1,2,4)]
coordinate <- gsub("[POINT()]","", mta$the_geom)
readcoor <-read.table(text =coordinate, sep = " ", colClasses = "character")
readcoor[c(2:3)]
colnames(readcoor) <- c("long","lat")
newmta <-cbind(mta,readcoor)