sample<-read.csv("/Users/Bianbian/Desktop/dat.csv")

sample2= sample
for (i in 3001:4000){
  longlat = as.numeric(geocode(as.character(sample[i,2])))
  sample2[i,3:4] = longlat
}
result2

write.csv(sample2,"data3441.csv")