
library(tidyr)
library(dplyr)

#dane pochodzą z banku danych lokalnych https://bdl.stat.gov.pl/BDL/start
ceny=read.csv2("CENY_2917_CTAB_20161208221319.csv")
wynagrodzenia=read.csv2("WYNA_2497_CTAB_20161208213259.csv")

wynagrodzenia %>% 
	gather(rok, pensja, -Kod, -Nazwa) %>%
	rowwise %>%
	mutate(rok=gsub("ogółem\\.(.*)\\.\\.zł\\.", "\\1", rok))  %>%
	ungroup %>% filter(rok %in% c("2006", "2015")) -> wynagrodzenia
	
ceny$X=NULL
names(ceny)=gsub("czerwiec\\.", "", names(ceny))
	
ceny %>%
	filter(!grepl("Region", Nazwa)) %>%
	gather(towar, cena, -Kod, -Nazwa) %>%
	rowwise %>%
	mutate(rok=gsub(".*cena\\.(.*)\\.\\.zł\\.", "\\1", towar),
				 towar=gsub("(.*)cena\\..*\\.\\.zł\\.", "\\1", towar)) %>%
	ungroup -> ceny

#gdzie jest najwieksza sila nabywcza? jak sie zmieniala w stosunku do Polski w roku 2006
ceny %>%
	filter(Nazwa=="POLSKA", rok=="2006") %>%
	inner_join(wynagrodzenia, by=c("Kod", "Nazwa", "rok")) %>%
	mutate(ile=pensja/cena) %>%
	select(-Kod, -rok) -> ceny_polska

ceny %>%
	inner_join(wynagrodzenia, by=c("Kod", "Nazwa", "rok")) %>%
	mutate(ile=pensja/cena) %>%
	inner_join(ceny_polska, by=c("towar")) %>% 
	group_by(rok, Nazwa.x, towar) %>%
	summarise(sila_nabywcza=ile.x/ile.y, Kod=Kod[1]) %>% 
	summarise(sila_nabywcza=median(sila_nabywcza, na.rm=T)) %>%
	mutate(Nazwa.x=tolower(Nazwa.x)) -> sila_nabywcza
