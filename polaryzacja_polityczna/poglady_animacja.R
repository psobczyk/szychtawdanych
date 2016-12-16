#' 
#' Piotr Sobczyk
#' 
#' szychtawdanych.pl
#'
 
##################################################################
###### Porównanie PO i PiS 2013 - 2015, rozkład poglądów #########
########### Każda osoba rozpatrywana jest osobno #################
### Patrzymy w którym kwantylu dla danego pytania się znajduje ###
##################################################################

library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(animation)

#ręcznie wczytanie dane z pakietu Diagnoza
load("osobyDict.rda")
load("osoby.rda")


#zestawienie dostępnych pytań
# osobyDict %>% rowwise() %>%
# 	filter(grepl(pattern="fp58_", name)) %>% View
# osobyDict %>% rowwise() %>%
# 	filter(grepl(pattern="gp54_", name)) %>% View
# osobyDict %>% rowwise() %>%
# 	filter(grepl(pattern="hp57_", name)) %>% View

liberalizm2011=c("fp58_3", "fp58_10", "fp58_16", "fp58_18")
konserwatyzm2011=c("fp58_11", "fp58_13", "fp58_22")

liberalizm2013=c("gp54_03", "gp54_07", "gp54_09", "gp54_16", "gp54_22")
konserwatyzm2013=c("gp54_10", "gp54_11", "gp54_12", "gp54_19", "gp54_21")

liberalizm2015=c("hp57_03", "hp57_08", "hp57_17", "hp57_20")
konserwatyzm2015=c("hp57_09", "hp57_10", "hp57_15", "hp57_18")

#2015

#data.frame pytanie, odpowiedź, ,,kwantyl liberalizmu"
df2015=NULL
for(question in c(liberalizm2015)){
	temp=data.frame(question=question, answer=1:7, quantile=cumsum(table(osoby[,question]))/sum(table(osoby[,question])))
	df2015=rbind(temp,df2015)
}
for(question in c(konserwatyzm2015)){
	temp=data.frame(question=question, answer=1:7, quantile=1-cumsum(table(osoby[,question]))/sum(table(osoby[,question])))
	df2015=rbind(temp,df2015)
}

selectedCols=match(c("numer150730", "hp101", liberalizm2015, konserwatyzm2015), names(osoby))
osoby %>%
	filter(hp101 %in% c(1:6), !is.na(hp101)) %>% 
	select(selectedCols) %>% 
	gather(key, value, -hp101, -numer150730) %>%
	inner_join(df2015, by=c("key"="question", "value"="answer")) %>%
	mutate(partia=factor(hp101)) %>%
	filter(partia %in% c(1,2)) %>%
	select(partia, poglady=quantile) -> b2015


#2013

#data.frame pytanie, odpowiedź, kwantyl liberalizmu
df2013=NULL
for(question in c(liberalizm2013)){
	temp=data.frame(question=question, answer=1:7, quantile=cumsum(table(osoby[,question]))/sum(table(osoby[,question])))
	df2013=rbind(temp,df2013)
}
for(question in c(konserwatyzm2013)){
	temp=data.frame(question=question, answer=1:7, quantile=1-cumsum(table(osoby[,question]))/sum(table(osoby[,question])))
	df2013=rbind(temp,df2013)
}


selectedCols=match(c("numer150730", "gp98", liberalizm2013, konserwatyzm2013), names(osoby))
osoby %>%
	filter(gp98 %in% c(1:7), !is.na(gp98)) %>% 
	select(selectedCols) %>% 
	gather(key, value, -gp98, -numer150730) %>%
	inner_join(df2013, by=c("key"="question", "value"="answer")) %>%
	mutate(partia=factor(gp98)) %>%
	filter(partia %in% c(1,7)) %>% 
	select(partia, poglady=quantile) -> b2013

#2011

#data.frame pytanie, odpowiedź, kwantyl liberalizmu
df=NULL
for(question in c(liberalizm2011)){
	temp=data.frame(question=question, answer=1:7, quantile=cumsum(table(osoby[,question]))/sum(table(osoby[,question])))
	df=rbind(temp,df)
}
for(question in c(konserwatyzm2011)){
	temp=data.frame(question=question, answer=1:7, 
									quantile=c(1, 1-(cumsum(table(osoby[,question]))/sum(table(osoby[,question])))[-7]))
	df=rbind(temp,df)
}


selectedCols=match(c("numer150730", "fp106", liberalizm2011, konserwatyzm2011), names(osoby))
osoby %>%
	filter(fp106 %in% c(1:6), !is.na(fp106)) %>% 
	select(selectedCols) %>% 
	gather(key, value, -fp106, -numer150730)  %>%
	inner_join(df, by=c("key"="question", "value"="answer")) %>%
	mutate(partia=factor(fp106)) %>%
	filter(partia %in% c(1,5)) %>%
	select(partia, poglady=quantile) -> b2011




### przetwarzanie, wyluskanie nazw partii
levels(b2011$partia)=gsub("(.*)\\(.*", "\\1", attr(attr(osoby$fp106, "labels"), "names"))[2:7]
levels(b2013$partia)=gsub("(.*)\\(.*", "\\1", attr(attr(osoby$gp98, "labels"), "names"))[2:8]
levels(b2015$partia)=gsub("(.*)\\(.*", "\\1", attr(attr(osoby$hp101, "labels"), "names"))[2:7]
b2015$partia=factor(b2015$partia, levels = rev(levels(b2015$partia)))

#wybor kolorow
partia_colors=RColorBrewer::brewer.pal(8, "Paired")[c(2,8)]


ggplot(b2011, aes(x=poglady, fill=partia, group=partia)) +
	geom_density(bw=0.15, alpha=0.7) +
	theme_fivethirtyeight(base_size = 24) +
	scale_x_continuous("", breaks=c(0.1, 0.9), limits = c(0,1), labels=c("liberalne", "konserwatywne")) +
	scale_y_continuous("", breaks=NULL, limits = c(0,1.35)) +
	scale_fill_manual("", values = partia_colors) +
	guides(alpha=FALSE, fill=guide_legend(override.aes = aes(alpha=1))) +
	theme(plot.background=element_rect(fill="white"), panel.background=element_rect(fill="white"),
				axis.text.x=element_text(angle=0), plot.title=element_text(hjust=0.5),plot.subtitle=element_text(hjust=0.5),
				panel.grid.major.x=element_blank()) +
	ggtitle("Poglądy wyborców", subtitle = "2011") -> p2011

ggplot(b2013, aes(x=poglady, fill=partia, group=partia)) +
	geom_density(bw=0.15, alpha=0.7) +
	theme_fivethirtyeight(base_size = 24) +
	scale_x_continuous("", breaks=c(0.1, 0.9), limits = c(0,1), labels=c("liberalne", "konserwatywne")) +
	scale_y_continuous("", breaks=NULL, limits = c(0,1.35)) +
	scale_fill_manual("", values = partia_colors) +
	guides(alpha=FALSE, fill=guide_legend(override.aes = aes(alpha=1))) +
	theme(plot.background=element_rect(fill="white"), panel.background=element_rect(fill="white"),
				axis.text.x=element_text(angle=0), plot.title=element_text(hjust=0.5),plot.subtitle=element_text(hjust=0.5),
				panel.grid.major.x=element_blank()) +
	ggtitle("Poglądy wyborców", subtitle = "2013") -> p2013

ggplot(b2015, aes(x=poglady, fill=partia, group=partia, alpha=0.2)) +
	geom_density(bw=0.15, alpha=0.7) +
	theme_fivethirtyeight(base_size = 24) +
	scale_x_continuous("", breaks=c(0.1, 0.9), limits = c(0,1), labels=c("liberalne", "konserwatywne")) +
	scale_y_continuous("", breaks=NULL, limits = c(0,1.35)) +
	scale_fill_manual("", values = partia_colors) +
	guides(alpha=FALSE, fill=guide_legend(override.aes = aes(alpha=1))) +
	theme(plot.background=element_rect(fill="white"), panel.background=element_rect(fill="white"),
				axis.text.x=element_text(angle=0), plot.title=element_text(hjust=0.5), plot.subtitle=element_text(hjust=0.5),
				panel.grid.major.x=element_blank()) +
	ggtitle("Poglądy wyborców", subtitle = "2015") -> p2015



saveGIF({
	show(p2011)
	show(p2013)
	show(p2015)
}, movie.name="polityka.gif", interval=1, ani.width=800, ani.height=600)

