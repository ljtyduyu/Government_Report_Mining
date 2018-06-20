## !/user/bin/env RStudio 1.1.423
## -*- coding: utf-8 -*-
## Document Acquisition

library("rvest")
library("dplyr")
library("magrittr")
library("doParallel")      
library("foreach") 


Links_data <- read.csv(
  "./data/Reports_links.csv",
  stringsAsFactors = FALSE
  ) %>% arrange(Year)


Get_Corpus_Report <- function(i){
  url = grep(i,Links_data$Year) %>% Links_data$Links[.]
  read_html(url) %>% 
    html_nodes("td.p1,tr > td,div.pages_content") %>% 
    html_text("both") %>% 
    cat(file = sprintf("./data/Corpus/%d.txt",i))
  }

system.time({
  if (!dir.exists("./data/Corpus")){
    dir.create("./data/Corpus")
  } 
  cl<- makeCluster(4)      
  registerDoParallel(cl)    
  tryCatch({ 
    foreach(
      i= Links_data$Year,  
      .combine = c,
      .packages = c("rvest","magrittr")
    ) %dopar% Get_Corpus_Report(i)
  },  error = function(e) {
    print(e)
  }, 
  finally = stopCluster(cl)
  )
}) 


