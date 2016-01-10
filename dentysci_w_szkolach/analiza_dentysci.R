#' 
#' Piotr Sobczyk, szychtawdanych.pl
#' 
#' Analiza pomysłu dentysy w każdej szkole
#' 
library(dplyr)
library(ggplot2)

setwd("~/szychta_w_danych/dentysci_w_szkolach/")
szkoly <- read.csv(file = "00003.csv", skip = 6, stringsAsFactors = FALSE)
summary(szkoly)

szkoly$teryt = paste0(szkoly$woj, szkoly$pow, szkoly$gm)
szkoly$Klasa.wielk. <- factor(szkoly$Klasa.wielk., levels = c(3,1,2),
                              labels=c("wieś", "miasto do 5 tys.mieszkańców",
                                       "miasto powyżej 5 tys.mieszkańców"))

#wybierzemy szkoly publiczne, niespecjalne, niezwiązane organizacyjnie i prowadzone przez państwo
niepanstwowe <- c(22, 23, 27, 28, 29, 30, 31, 32, 33)
szkoly %>%
  filter(Spec..szkoły==100,
         Związ..organiz.==100,
         Złożoność<=2,
         Publiczność==1,
         ! Identyfikacja.organu.prowadzącego %in% niepanstwowe) -> szkoly_publiczne

szkoly_publiczne$Uczniowie..wychow...słuchacze <- as.numeric(szkoly_publiczne$Uczniowie..wychow...słuchacze)

#dołaczamy informację o województwach
wojewodztwa <- read.csv("wojewodztwa_kody.txt", header=FALSE)
szkoly_publiczne %>%
  group_by(woj) %>%
  summarise(mediana=median(Uczniowie..wychow...słuchacze)) -> mediany_wojewodztwa

szkoly_publiczne$woj = factor(szkoly_publiczne$woj, 
                              levels=wojewodztwa$V2[order(mediany_wojewodztwa$mediana)],
                              labels=as.character(wojewodztwa$V1[order(mediany_wojewodztwa$mediana)]))

# łączna długość czasu pracy w szkole (bez lipca, sierpnia, połowy stycznia i połowy grudnia)
godzin_pracy = 2016 -168 - 176 - 76 - 84
szkoly_publiczne$etaty <- szkoly_publiczne$Uczniowie..wychow...słuchacze*4/godzin_pracy

# w ilu szkołach będzie więcej niż jeden etat?
sum(szkoly_publiczne$etaty>=1)
summary(szkoly_publiczne$etaty)
#### rysunki

ggplot(szkoly_publiczne) +
  geom_boxplot(aes(x=woj, y=etaty, fill=woj)) +
  scale_y_log10("% etatu", breaks=c(0.05, 0.1, 0.2, 0.4, 0.6, 0.8, 1, 2, 4),
                labels=c(5, 10, 20, 40, 60, 80, 100, 200, 400)) +
  xlab("") + guides(fill=FALSE) + myTheme + coord_flip() +
  ggtitle("Zapotrzebowanie na denystów w szkołach podstawowych według województw")
ggsave("dentysci_wojewodztwa_etaty.jpg", width = 18, height = 8)  

ggplot(szkoly_publiczne) +
  geom_boxplot(aes(x=Klasa.wielk., y=Uczniowie..wychow...słuchacze, fill=Klasa.wielk.)) +
  scale_y_log10("Liczba uczniów", breaks=c(10, 100, 200, 400, 800, 1500)) +
  xlab("") + guides(fill=FALSE) + myTheme + 
  ggtitle("Rozkład wielkości szkół podstawowych")
ggsave("liczba_uczniow.jpg", height=8, width=12)  

# a jakie są koszty i jak będą wykorzystywane?
potrzebne_etaty = sum(pmin(szkoly_publiczne$Uczniowie..wychow...słuchacze*4/godzin_pracy,1))

koszt_gabinetu = 1e5
koszt_gabinetu*(nrow(szkoly_publiczne)-potrzebne_etaty)

potrzebne_etaty*8000*12

#wielkosc a wies, miast
aggregate(szkoly_publiczne$Uczniowie..wychow...słuchacze, 
          by=list(szkoly_publiczne$Klasa.wielk.), 
          function(x) quantile(x, c(0.05, 0.15, 0.5, 0.85, 0.95)))

#' Waterfall ze szkołami podstawowymi

#maszynka do uzyskiwania liczb
# niepanstwowe <- c(22, 23, 27, 28, 29, 30, 31, 32, 33)
# klasaWielkosci <- levels(szkoly$Klasa.wielk.)
# szkoly %>%
#   filter(Publiczność==1,
#          Spec..szkoły==100,
#          ! Identyfikacja.organu.prowadzącego %in% niepanstwowe,
#          Złożoność <=2) %>%
#          summarise(length(woj))
# Klasa.wielk. == klasaWielkosci[3]) %>%


data_waterfall <- data.frame(desc=c("Ogółem", "Niepubliczne", "Publiczne", "Specjalna", "Zwykła", 
                                    "Nieprowadzone przez\ninstytucję państwo", 
                                    "Prowadzone przez\ninstytucję państwo", "Wieś", 
                                    "Miasto do\n5 tys.mieszkańców", "Miasto powyżej\n5 tys.mieszkańców"))
data_waterfall$desc <- factor(data_waterfall$desc, levels = data_waterfall$desc)
data_waterfall$amount <- c(13679, 1221, 12458, 744, 11714, 622, 11092, 7607, 340, 3145)
data_waterfall$id <- seq_along(data_waterfall$amount)
data_waterfall$type <- c("total", "change", "total", "change", "total", "change", "total",
                         "change", "change", "change")

endPos <- data_waterfall$amount[1]
startPos <- 0
for(i in 2:10){
  if(data_waterfall$type[i]=="change"){
    if(data_waterfall$type[i-1]=="change"){
      endPos[i]=startPos[i-1]
      startPos[i]=startPos[i-1]-data_waterfall$amount[i]
    } else {
      endPos[i]=endPos[i-1]
      startPos[i]=endPos[i-1]-data_waterfall$amount[i]
    }
  } else{
    endPos[i]=data_waterfall$amount[i]
    startPos[i]=0
  }
}

data_waterfall$start <- startPos
data_waterfall$end <- endPos


ggplot(data_waterfall, aes(desc, fill = type)) + 
  geom_rect(aes(x = desc, xmin = id - 0.45, xmax = id + 0.45, 
                ymin = end, ymax = start)) +
  scale_fill_manual(values=blues9[c(3,7)]) + guides(fill=FALSE) +
  geom_text(data = subset(data_waterfall, type == "total"), 
            aes(id, end, label = amount), nudge_y = 200, size = 7) +
  geom_text(data = subset(data_waterfall, type == "change"), 
            aes(id, end, label = amount), nudge_y = -200, size = 7) +
  ylab("Liczba szkół") + xlab("") + waterfallTheme +
  ggtitle("Szkoły podstawowe w Polsce")
ggsave("szkoly_waterfall.jpg", width=18, height = 10)