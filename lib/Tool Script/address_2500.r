sample<-read.csv("/Users/Bianbian/Desktop/canting.csv",header=FALSE)
result2= data.frame()
for (i in 1:nrow(sample)){
  longlat = as.numeric(geocode(as.character(sample[i,2])))
  result2 = rbind(result2,longlat)
  colnames(result2) = c("long","lat")
}
result2
samp7<-cbind(sample,result2)
write.csv(samp7,"samp7.csv")