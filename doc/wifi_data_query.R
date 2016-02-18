Free_wfif<- read.csv("~/Desktop/Applied Data Science/project2-group1/data/What_to_put_on_map/Free_WiFi_Hotspots_09042005.csv")
library("ggmap")
location = Free_wfif[,8:9]
result = vector()
for (i in 1:nrow(location)){
        
        wifi = revgeocode(as.numeric(location[i,2:1]), output = "more")
        wifi = as.numeric(levels(wifi$neighborhood))
        result = rbind(result,wifi)
        
}
result = data.frame(result)
zipcode_count = count(result,"result")
colnames(neighborhood_count) = c("neighborhood","counts")