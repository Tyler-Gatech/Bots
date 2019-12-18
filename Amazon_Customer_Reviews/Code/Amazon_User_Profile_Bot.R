#The purpose of this code is to scrape reviews Amazon's customer profile pages. 
#These reviews load dynamically on the page as the end-user scrolls down, 
# and therefore traditional web scraping methods do not work. 
# I've built a bot in R using RSelenium that navigates a Chrome browser, scrolls to the bottom of the page
# then scrapes all fo the reviews. 

#Libraries used
library(tidyverse)
library(rvest)
library(stringr)
library(httr)
library(rvest)
library(RSelenium) 

#Open the browser using the RSelenium package, you may have to set the chrome version here. 
driver <- rsDriver(browser=c("chrome"), port = 4575L)
remote_driver <- driver[["client"]]
remote_driver$open()

#We are going to bring in our list users from the data scraped in Part 1, "Amazon_Review_Scraping_Lovevery.R"
#This file can be downloaded from Github as well
#https://github.com/Tyler-Gatech/Bots/tree/master/Amazon_Customer_Reviews/Data
review_df <- readRDS("./Desktop/Github/Bots/Amazon_Customer_Reviews/Data/reviews_all_df_B075R8BXXC_2019-12-17.RDS")


#Create a blank data frame to house the information
user_df <- as.data.frame(matrix(data = NA, nrow = 0 , ncol =3))
colnames(user_df) <- c("links", "prod_code", "user")


#Compile the user list
user_list <- review_df$link_id

counter <- 0
#user <- user_list[1]
for (user in user_list[1:5]){
  
  counter <- counter + 1
  print(paste(counter, "of", length(user_list)))
  
  #Navigate to the user page
  rd$navigate(paste0("https://www.amazon.com/gp/profile/amzn1.account.",user,"/ref=cm_cr_arp_d_gw_btm?ie=UTF8"))
  
  #Scroll down to the bottom of the page to gather all the reviews
  #pause for a few seconds to allow page load
  Sys.sleep(sample(seq(2, 3, by=0.001), 1))
  
  #you need to scroll to the bottom of each user page to load the new reviews dynamically 
  webElem <- rd$findElement("css", "body")
  webElem$sendKeysToElement(list(key = "end"))
  
  #pause once again for page load
  Sys.sleep(sample(seq(2, 3, by=0.001), 1))
  
  #grab the product links and product code the customer has left reviews for
  prod <- rd$findElements(using = "css selector", '.profile-at-product-box-link')
  
  links <- as.vector(NA)
  prod_code <- as.vector(NA)
  
  for (link in 1:length(prod)){
    links[link] <- prod[[link]]$getElementAttribute('href')[[1]]
    prod_code[link] <- gsub("dp/","",str_extract(links[link],"(dp/)[A-Z0-9]{10}"))
  }
  
  #combining into a df
  temp_df <- cbind(links, prod_code, user = user )
  user_df <- rbind(user_df, temp_df)
  
}




