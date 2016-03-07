#### wojewodztwa ####

require(ggplot2)
require(ggthemes) #tufte_theme
require(ggmap)
require(dplyr)
require(scales) #pretty breaks
require(rgdal)
require(rgeos)

Wojewodztwa <- readOGR("wojewodztwa/", "wojewodztwa", encoding = "utf8")
nazwy <- data.frame(id=as.character(0:15), teryt=Wojewodztwa$jpt_kod_je,  woj=Wojewodztwa$jpt_nazwa_)
nazwy$id <- as.character(nazwy$id)

summary(Wojewodztwa)
wojewodztwa <- gSimplify(Wojewodztwa, tol=50, topologyPreserve=TRUE)
wojewodztwa <- spTransform(wojewodztwa, CRS("+proj=longlat +datum=WGS84"))
Wojewodztwa <- fortify(wojewodztwa)


wynagrodzeniaWoj <- read.csv("wynagrodzenie_wojewodztwa_brutto_2002_2014.csv", dec = ".")
wynagrodzeniaWoj$VALUE <- as.numeric(as.character(wynagrodzeniaWoj$VALUE))
wynagrodzeniaWoj$TERYT_NAME <- tolower(wynagrodzeniaWoj$TERYT_NAME)
wynagrodzeniaWoj <- tidyr::spread(wynagrodzeniaWoj, YEAR, VALUE)
summary(wynagrodzeniaWoj)

plotData2 <- inner_join(Wojewodztwa, 
                        inner_join(wynagrodzeniaWoj, nazwy, 
                                   by = c("TERYT_NAME"="woj")), 
                        by = c("id"="id"))

names <- c("Białystok", "Bydgoszcz", "Gdańsk", "Gorzów Wielkopolski",
           "Katowice", "Kielce", "Kraków", "Lublin", "Łódź",
           "Olsztyn", "Opole", "Poznań", "Rzeszów", "Szczecin",
           "Toruń", "Warszawa", "Wrocław", "Zielona Góra")
places <- data.frame(t(sapply(names, function(x) unlist(geocode(x, source = "google")))))
places$name <- names

trueCentroids = data.frame(gCentroid(wojewodztwa,byid=TRUE))
trueCentroids$id <- rownames((trueCentroids))
places2 <- inner_join(trueCentroids, 
                      inner_join(wynagrodzeniaWoj, nazwy, 
                                 by = c("TERYT_NAME"="woj")), 
                      by = c("id"="id"))

ggplot(plotData2, aes(x = long, y = lat)) +
  geom_polygon(aes(group = group, fill = 100*`2014`/`2002`-100, alpha = 1)) +
  scale_fill_distiller("Zmiana w %", palette = "RdYlGn", breaks = pretty_breaks(n = 12),
                       trans = "reverse") +
  scale_alpha(guide = FALSE) +
  labs(fill = "") +
  guides(fill = guide_legend(reverse = TRUE, override.aes = 
                               list(alpha = 1))) +
  ggtitle("Wzrost wynagrodzeń w latach 2002-2014 w podziale na województwa\n
          W ramkach przeciętne wynagrodzenie w roku 2014") + 
  xlab("") + ylab("") + theme_tufte() + theme_map() +
  annotate("point", x=places$lon, y=places$lat, color="black") + 
  annotate("text", x=places$lon, y=places$lat+.1, label=places$name, color="black", fontface=4, size=6) +
  geom_label(data=places2[c(3,4,6,12),], aes(x=x, y=y, label=floor(`2014`)), 
             nudge_x = 0, nudge_y = -0.25, show.legend = FALSE) +
  geom_label(data=places2[-c(3,4,6,12),], aes(x=x, y=y, label=floor(`2014`)), 
             nudge_x = 0, nudge_y = 0, show.legend = FALSE) +
  theme(legend.title = element_text(size = 15),
        legend.text = element_text(size = 14))