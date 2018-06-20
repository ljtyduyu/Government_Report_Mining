## !/user/bin/env RStudio 1.1.423
## -*- coding: utf-8 -*-
## Pages_links Acquisition

library("rvest")
library("stringr")
library("Rwordseg")
library("wordcloud2")
library("dplyr")


Get_Reports_Links <- function(){
url <- "http://www.gov.cn/guowuyuan/baogao.htm"
txt<-read_html(url) %>% 
     html_nodes("#history_report") %>% 
     html_nodes("p") %>% 
     html_text()
Base <- read_html(url) %>% html_nodes("div.history_report")
Year  <- Base %>% html_nodes("a") %>% html_text(trim = TRUE) %>% as.numeric()
Links <- Base %>% html_nodes("a") %>% html_attr("href")      %>% str_trim("both")
Reports_links <- data.frame(
  Year = Year,
  Links = Links,
  stringsAsFactors = FALSE
 )
 return(Reports_links)
}

Reports_links <- Get_Reports_Links()


if (!dir.exists("data")){
  dir.create("data")
  write.csv(
  Reports_links,
  "./data/Reports_links.csv",
  row.names=FALSE
  )  
} 

  




