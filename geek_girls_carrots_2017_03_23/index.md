---
title       : Dobry, zły i brzydki
subtitle    : o wizualizacji danych w języku R
author      : Piotr Sobczyk
date        : "23 marca 2017"
job         : szychtawdanych.pl
logo        : szychta_transparent.png
biglogo     : szychta_transparent.png
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

<style>
.title-slide {
  background-color: #FFFFFF; /* #EDE0CF; ; #CA9F9D*/
}
article li {
  font-size: 27px;
  line-height: 160%;
}
</style>

## Motywacja



<div style='text-align: center;'>
    <img height='550' src='https://images.alphacoders.com/130/13013.jpg' />
</div>


--- &twocol w1:50% w2:50%

## Po co wizualizacja?

*** =left

> * <b>Użyteczność</b>: podejmowanie decyzji w oparciu o dane
> * <b>Maksymalizacja wpływu</b>: obraz jako medium wyników analizy 
> * <b>Estetyka</b>

*** =right

<!--
<div style='text-align: center;'>
    <img height='450' src='http://herdingcats.typepad.com/.a/6a00d8341ca4d953ef01a511d248cc970c-pi' />
</div>
-->

<div style='text-align: center;'>
    <img height='450' src='assets/img/howtolie.jpg' />
</div>



--- .segue .quote .dark

<q> Tak więc estetyka może być pomocna w życiu <br> nie należy zaniedbywać nauki o pięknie</q>

<style>
.dark q {
  color: white;
  text-align:center;
}
</style>

--- bg:#FFF
## Jak zabieramy się za wizualizację?

> * Chcemy opowiedziec pewną historię, wizualizacja jest środkiem wyrazu
> * Notka PAP czy pobłębiona analiza?
> * Książka kucharska czy ,,Czarodziejska Góra"?
> * Strona techniczna

--- bg:#FFF
## Dobra wizualizacja

<!--https://pbs.twimg.com/media/C7DFVTgVwAUabFO.jpg-->

<div style='text-align: center;'>
    <img height='500' src='assets/img/C7DFVTgVwAUabFO.jpg' />
</div>

--- bg:#FFF
## Dobra wizualizacja

> * Jasny, zapadający w pamięć przekaz
> * Dopasowana do odbiorców (czytelnicy gazet, współpracownicy, kierownicy)
> * Dopasowana do sytuacji w jakiej będą odbierane
> * Wywieraja wpływ, przekazuje wiedzę, poszerza świadomość

<div style='text-align: center;'>
    <img height='350' src='assets/img/C7DFVTgVwAUabFO.jpg' />
</div>

--- bg:#FFF
## Zła wizualizacja

<div style='text-align: center;'>
    <img height='500' src='assets/img/z19705009QJak-wysokie-emerytury-dostaja-Polacy-.jpg' />
</div>

--- bg:#FFF
## Zła wizualizacja

<!-- http://smarterpoland.pl/wp-content/uploads/2017/01/z19705009QJak-wysokie-emerytury-dostaja-Polacy-.jpg -->

> * Celowo wprowadza w błąd odbiorcę
> * Przesycona zbędnymi informacjami
> * Niedokładna

<div style='text-align: center;'>
    <img height='350' src='assets/img/z19705009QJak-wysokie-emerytury-dostaja-Polacy-.jpg' />
</div>

--- bg:#FFF
## Zła wizualizacja

<!--http://smarterpoland.pl/wp-content/uploads/2017/01/Screen-Shot-2016-12-25-at-23.40.46-1024x1012.png -->
<div style='text-align: center;'>
    <img height='550' src='assets/img/Screen-Shot-2016-12-25-at-23.40.46-1024x1012.png'/>
</div>


--- bg:#FFF
## Brzydka wizualizacja

<!--http://smarterpoland.pl/wp-content/uploads/2017/01/Screen-Shot-2016-12-25-at-23.13.38.png -->
<div style='text-align: center;'>
    <img height='500' src='assets/img/Screen-Shot-2016-12-25-at-23.13.38.png' />
</div>

--- &twocol w1:50% w2:50%
## Brzydka wizualizacja

*** =left

> * Trudna w interpretacji
> * Niecelowo wprowadzająca w błąd
> * Zawiera zbędne i nudne informacje

*** =right
<!--http://smarterpoland.pl/wp-content/uploads/2017/01/Screen-Shot-2016-12-25-at-23.13.38.png -->
<div style='text-align: center;'>
    <img height='450' src='assets/img/Screen-Shot-2016-12-25-at-23.13.38.png' />
</div>

--- bg:#FFF
## Case study

> * Dane dotyczące PKB na mieszkańca i ludności na świecie
> * Chcemy pokazać nierówności społeczne
> * Dane pochodzą z serwisu gapminder https://www.gapminder.org


--- bg:#FFF
## Kolory

> * Wyróżnienie informacji, umożliwienie rozpoznania grup
> * Dobór palety barw odpowiedniej do danych
> * Symulator schorzeń wzroku, np. http://www.color-blindness.com/coblis-color-blindness-simulator/


--- bg:#FFF
## Wybór palety barw 

![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-2-1.png)


--- bg:#FFF
## Wybór palety barw 

> * Skala ilościowa (uporządkowana)
> * Skala uporządkowana rozbieżna (z elementem neutralnym)
> * Skala jakościowa (nieuporządkowana)


--- bg:#FFF
## Wybór palety barw 




<img src="assets/fig/unnamed-chunk-4-1.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" style="display: block; margin: auto;" />

--- bg:#FFF
## Wybór palety barw 
<img src="assets/fig/unnamed-chunk-5-1.png" title="plot of chunk unnamed-chunk-5" alt="plot of chunk unnamed-chunk-5" style="display: block; margin: auto;" />

--- bg:#FFF
## Wybór palety barw 
<img src="assets/fig/unnamed-chunk-6-1.png" title="plot of chunk unnamed-chunk-6" alt="plot of chunk unnamed-chunk-6" style="display: block; margin: auto;" />

--- bg:#FFF
## Wybór palety barw 
<img src="assets/fig/unnamed-chunk-7-1.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" style="display: block; margin: auto;" />

--- bg:#FFF
## Wybór palety barw 
<img src="assets/fig/unnamed-chunk-8-1.png" title="plot of chunk unnamed-chunk-8" alt="plot of chunk unnamed-chunk-8" style="display: block; margin: auto;" />

--- bg:#FFF
## Sposób przedstawienia danych

> * Te same dane można przedstawić na wiele sposobów
> * Jaki cel chcemy osiągnąć?

--- bg:#FFF
## Sposób przedstawienia danych

<img src="assets/fig/unnamed-chunk-9-1.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" style="display: block; margin: auto;" />

--- bg:#FFF
## Sposób przedstawienia danych - odpowiednia skala

<img src="assets/fig/unnamed-chunk-10-1.png" title="plot of chunk unnamed-chunk-10" alt="plot of chunk unnamed-chunk-10" style="display: block; margin: auto;" />

--- bg:#FFF
## Sposób przedstawienia danych - kształt, kolor, rozmiar punktów

<img src="assets/fig/unnamed-chunk-11-1.png" title="plot of chunk unnamed-chunk-11" alt="plot of chunk unnamed-chunk-11" style="display: block; margin: auto;" />

--- bg:#FFF
## Sposób przedstawienia danych - kształt, kolor, rozmiar punktów

<iframe src="diagram.html" width=100% height=100% allowtransparency="true"> </iframe>


--- bg:#FFF
## Inaczej



<img src="assets/fig/unnamed-chunk-14-1.png" title="plot of chunk unnamed-chunk-14" alt="plot of chunk unnamed-chunk-14" style="display: block; margin: auto;" />


--- bg:#FFF

<iframe src="uszeregowane_pkb.html" width=100% height=100% allowtransparency="true"> </iframe>

--- bg:#FFF

<img src="assets/fig/unnamed-chunk-16-1.png" title="plot of chunk unnamed-chunk-16" alt="plot of chunk unnamed-chunk-16" style="display: block; margin: auto;" />

--- bg:#FFF
## Źródła

* Przemysław Biecek, ,,Odkrywać, Ujawniać, Objaśniać! Zbiór esejów o sztuce prezentowania danych", 2014
* Edward Tufte, ,,Beautiful evidence"
* Gapminder, https://www.gapminder.org
* Symulator schorzeń wzroku http://www.color-blindness.com/coblis-color-blindness-simulator/
* https://www.r-bloggers.com/data-visualization-part-1/
* https://lisacharlotterost.github.io/2016/04/22/Colors-for-DataVis/
* Szychta w danych, www.szychtawdanych.pl
* pakiety: **ggplot2**, **highcharter**
