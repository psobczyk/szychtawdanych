
setwd("~/szychta_w_danych/dane_publiczne/")
require(rjson)
library(httr)
httr::set_config(config =  httr::config( ssl_verifypeer = 0L ) )

#znajdz wszystkie zasoby, dostępne w formacie csv
queryUrl <- "https://danepubliczne.gov.pl/api/3/action/package_search?fq=+res_format:CSV"
r <- GET(queryUrl)
http_status(r)
dat <- fromJSON(content(r, "text"))
dat <- fromJSON(readLines("~/szychta_w_danych/dane_publiczne/json_result"))
#sprawdzmy, które pliki csv da się rzeczywiscie pobrac

lapply(dat$result$results, function(x) {
	print(x$title)
	queryURL <- paste0( "https://danepubliczne.gov.pl/datastore/dump/", 
											x$resources[[1]]$id)
	r <- GET(queryURL)
	c(x$title, status_code(r))
})

#ten dostęp to trochę ściema
