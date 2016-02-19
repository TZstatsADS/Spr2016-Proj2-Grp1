crime <- read.csv("NYPD_7_Major_Felony_Incidents.csv")

a<-as.character(crime$Location.1)
b<-as.numeric(unlist(strsplit(gsub("[^0-9. ]","", unlist(a)),"[^0-9.]")))

lat = vector(length = length(b)/2)
lng = vector(length = length(b)/2)
count1 = 0
count2 = 0
for(i in 1:length(b)){
        print(i)
        if ((i%%2)!=0){
                count1 = count1 + 1
                lat[count1] = b[i]
        }
        else{
                count2 = count2 + 1
                lng[count2] = b[i]
        }
        
}
crime$lat <- lat
crime$lng <- lng


