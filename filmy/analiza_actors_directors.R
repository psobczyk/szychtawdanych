#all movies info

library(XML)

movies <- data.frame()
for(i in 1:7){
  filename <- paste0('http://www.boxofficemojo.com/alltime/world/?pagenum=', i, '&p=.htm')
  tables <- readHTMLTable(filename)
  movies <- rbind(movies, (tables[[2]])[-1,])
}

ind=which(movies$V2=="Bienvenue chez les Ch'tis")
movies$V9[ind] <- 2008
movies$V9 <- as.numeric(as.character( gsub("\\^","",movies$V9)))
movies$V4 <- as.numeric(as.character(gsub(",", "", gsub("\\$","",movies$V4))))
movies$V5 <- as.numeric(as.character(gsub(",", "", gsub("\\$","",movies$V5))))

movies$V5[ind] <- 1.4
movies$V4[ind] <- 246.6
movies$V5[228] <- 0.032

movies <- movies[,-c(5:8)]

names(movies) <- c("Rank", "Title", "Studio", "Unadjusted_Gross", "Year")
movies$Title <- as.character(movies$Title)
movies$Title <- gsub(" \\(\\d{4}\\)", "", movies$Title)
movies$Title <- gsub(pattern = "\\(.+\\)", "", x = movies$Title)
movies$Title <- gsub("Vs\\.", "vs\\.", movies$Title)
movies$Title <- gsub("Dr. Seuss' ", "", movies$Title)

movies$Title[movies$Title=="Marvel's The Avengers"] <- "The Avengers"
movies$Title[movies$Title=="X2: X-Men United"] <- "X-Men 2"
movies$Title[movies$Title=="Bienvenue chez les Ch'tis"] <- "Welcome to the Sticks"
movies$Title[movies$Title=="Marley and Me"] <- "Marley & Me"
movies$Title[movies$Title=="Die Hard 2: Die Harder" ] <- "Die Hard 2"
movies$Title[movies$Title=="Hansel and Gretel: Witch Hunters"] <- "Hansel & Gretel: Witch Hunters"
movies$Title[movies$Title=="Garfield: The Movie"] <- "Garfield"

#as downloading info about all 630 movies takes some time I recommend to
#read in from file
load("box_office_movie_info.Rdata")

movies2 <- NULL
for(i in 1:nrow(movies)){
  queryUrl <- paste0('http://www.omdbapi.com/?t=', gsub(":", "", gsub(" ", "+", movies$Title[i])), '&y=', movies$Year[i], '&plot=short&r=json')
  lookUp <- URLencode(queryUrl)
  rd <- readLines(lookUp, warn="F") 
  if(rd=="{\"Response\":\"False\",\"Error\":\"Movie not found!\"}"){
    queryUrl <- paste0('http://www.omdbapi.com/?t=', gsub(":", " ", gsub(" ", "+", movies$Title[i])), '&plot=short&r=json')
    lookUp <- URLencode(queryUrl)
    rd <- readLines(lookUp, warn="F") 
  }
  dat <- fromJSON(rd)
  
  if(is.null(dat$Director)){
    movies2 <- rbind(movies2,
                     director=cbind(movies[i,], NA))
  } else{
    directors <- strsplit(dat$Director, ", ")[[1]]
    movies2 <- rbind(movies2,
                     cbind(movies[i,], dat))
  }
  print(movies$Title[i])
}

movies2$Actors <- as.character(movies2$Actors)
actors <- paste(unlist(strsplit(movies2$Actors, ", ")))

plot.data <- sort(table(actors), decreasing = T)[1:20]
plot.data <- data.frame(name=gsub(" ", "\n", names(plot.data)), count=as.numeric(plot.data))
plot.data$name <- factor(plot.data$name, (plot.data$name))
plot.data$sex <- "1"
plot.data$sex[3] <- "2"

library(ggplot2)
ggplot(plot.data) +
  geom_bar(aes(x=name, y=count, fill=sex), stat="identity") +
  ylab("Liczba filmów") + xlab("") +
  scale_fill_discrete(guide=FALSE)


movies2$Director <- as.character(movies2$Director)
directors <- paste(unlist(strsplit(movies2$Director, ", ")))

plot.data <- sort(table(directors), decreasing = T)[1:21]
plot.data <- data.frame(name=gsub(" ", "\n", names(plot.data)), count=as.numeric(plot.data))
plot.data$name <- factor(plot.data$name, (plot.data$name))
plot.data <- plot.data[-2,]

ggplot(plot.data) +
  geom_bar(aes(x=name, y=count, fill="1"), stat="identity") +
  ylab("Liczba filmów") + xlab("") +
  scale_fill_discrete(guide=FALSE)
