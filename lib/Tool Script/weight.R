weight_calculation <- function(first_preference, second_preference,w1,w2,w3) {
  
  #file input
  wifi <- read.csv("# of wifi in each neighbor.csv")
  crime <- read.csv("num_crime_neighbor.csv")
  
  museum <- read.csv('museum in which neighbor.csv')
  natural <- read.csv('natural in which neighbor.csv')
  theater <- read.csv('theater in which neighbor.csv')
  opera<- read.csv('opera house in which neighbor.csv')
  gallery<-read.csv('art gallery in which neighbor.csv')
  
  
  #user input type: landmark, museum, natural, theater, opera, gallery, all
  #first_preference='museum' 
  #second_preference='opera'
  
  #user input weight : w1-wifi  w2-crime
  #w1=1
  #w2=1
  
  #weight calculation
  museum=as.data.frame(table(museum$NTAName))
  natural=as.data.frame(table(natural$NTAName))
  theater=as.data.frame(table(theater$NTAName))
  opera=as.data.frame(table(opera$NTAName))
  gallery=as.data.frame(table(gallery$NTAName))
  
  if(first_preference!='all' &first_preference!='landmark'){
    tmp1= eval(parse(text = first_preference))
    neighborpool<-tmp1$Var1
  }
  
  if(second_preference!='all' &second_preference!='landmark'){
    tmp2= eval(parse(text = second_preference))
    neighborpool<-intersect(tmp2$Var1,neighborpool)
  }
  neighborpool
  wifi<-data.frame(wifi,row.names = 'Var1')
  wifi<-wifi[neighborpool,]
  
  crime<-data.frame(crime,row.names = 'Var1')
  crime<-crime[neighborpool,]
  
  neighbor_score = w1 * wifi$Freq/sum(wifi$Freq)-w2*crime$Freq/sum(crime$Freq)
  neighbor_score=data.frame(neighborpool,neighbor_score)  
  
  
  #TOP 5 scored rows
  top_num = min(5,length(neighborpool))
  neighbor_score<-neighbor_score[order(neighbor_score[,2],decreasing = T),]
  neighbor_score
  maxs <- max(neighbor_score$neighbor_score)
  mins <- min(neighbor_score$neighbor_score)
  neighbor_score$neighbor_score<-scale(neighbor_score$neighbor_score, center = mins, scale = maxs - mins)
  return (neighbor_score[1:top_num,])
}



  
  
  
  