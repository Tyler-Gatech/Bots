library(tidyverse)
library(rvest)
library(stringr)

#Product in scope
#https://www.amazon.com/Lovevery-Developmental-Sensory-Development-Grounded/dp/B075R8BXXC/ref=sr_1_1_sspa?gclid=EAIaIQobChMI3_Or76y95gIVr__jBx0RxQcWEAAYASAAEgIQI_D_BwE&hvadid=237435144439&hvdev=c&hvlocphy=9003742&hvnetw=g&hvpos=1t1&hvqmt=e&hvrand=4787167367938848366&hvtargid=kwd-389935660510&hydadcr=690_9911060&keywords=lovevery+the+play+gym&qid=1576608642&sr=8-1-spons&psc=1&spLa=ZW5jcnlwdGVkUXVhbGlmaWVyPUExWTFZUTdTMDlBRFhOJmVuY3J5cHRlZElkPUEwMzQyOTE2M09YQTYyQU5VQ0w3MyZlbmNyeXB0ZWRBZElkPUEwNTQ5Njg3MkgwQk9aSjIyUkhRUyZ3aWRnZXROYW1lPXNwX2F0ZiZhY3Rpb249Y2xpY2tSZWRpcmVjdCZkb05vdExvZ0NsaWNrPXRydWU=

#Reviews
url <- "http://www.amazon.com/product-reviews/B075R8BXXC/?pageNumber=1"

#Creating a function to scrape each element of product reviews
scrape_amazon <- function(url){

  #read the html data
  doc <- read_html(url)
  
  #we use class headings in the html to gather the relevant infomration
  #In this case we only have one product, but this would be helpful if we were looping through product codes
  prod <- html_nodes(doc, "#productTitle") %>% 
    html_text() %>% 
    gsub("\n", "", .) %>% 
    trimws()
  
  
  # Parse relevant elements from HTML
  title <- doc %>%
    html_nodes("#cm_cr-review_list .a-color-base") %>%
    html_text()
  
  ids <- doc %>%
  html_nodes("#cm_cr-review_list") %>% 
    html_nodes("div") %>% 
    html_attr("id") %>% 
    grep("^R[a-zA-Z0-9]+$", ., value = TRUE) 
    
  
  review_ids <- unique(ids)
  
  author <- doc %>%
    html_nodes("#cm_cr-review_list .a-profile-name") %>%
    html_text()
  
  date <- doc %>%
    html_nodes("#cm_cr-review_list .review-date") %>%
    html_text() %>% 
    gsub(".*on ", "", .)
  
  review_format <- doc %>% 
    html_nodes(".review-format-strip") %>% 
    html_text() 
  
  stars <- doc %>%
    html_nodes("#cm_cr-review_list  .review-rating") %>%
    html_text() %>%
    str_extract("\\d") %>%
    as.numeric() 
  
  link_id <- doc %>%
    html_nodes("#cm_cr-review_list .a-profile") %>%
    html_attr("href") %>%
    str_extract("[A-Z0-9]{28}")
  
  comments <- doc %>%
    html_nodes("#cm_cr-review_list .review-text") %>%
    html_text() 
  
  suppressWarnings(n_helpful <- doc %>%
                     html_nodes(".a-expander-inline-container") %>%
                     html_text() %>%
                     str_extract("[0-9]+") %>%
                     as.numeric())
  
  
  # Combine attributes into a single data frame
  df <- data.frame(title, author, date, review_format, stars, comments, review_ids, link_id, n_helpful, stringsAsFactors = F)
  
  return(df)

}


# Test the scraper function
url <- "http://www.amazon.com/product-reviews/B075R8BXXC/?pageNumber=1"
reviews <- scrape_amazon(url)

#View the output
reviews

#Now we need to loop through each review page, there are  8 reviews per page,
#so let's calculate how many review pages we need  to look thorugh

#How many ratings on the product page?

doc <- read_html(url)

rating_class <- doc %>%
  html_nodes(".a-size-base.a-color-secondary") %>%
  html_text()

rating_text <- rating_class[str_detect(rating_class, "ratings")]
rating_count <- as.numeric(max(str_extract(rating_text, "\\d+"),0))

#10 reviews per page
loop_pages <- ceiling(rating_count/10)

#the product code from the url
 prod_code <- "B075R8BXXC"

# create empty object to write data into
reviews_all <- NULL
 

# loop over pages
for(page_num in 1:loop_pages){
 
  url <- paste0("http://www.amazon.com/product-reviews/",prod_code,"/?pageNumber=", page_num)
  reviews <- scrape_amazon(url)
  
  #random sleep on the scrape so we don't get kicked off by amazon
  Sys.sleep(sample(seq(2, 3, by=0.001), 1))
  
  #combine the reviews together
  reviews_all <- rbind(reviews_all, cbind(prod, reviews))
  print(page_num)
}

saveRDS(reviews_all, paste0("./Desktop/Github/Bots/Amazon Customer Reviews/Data/reviews_all_df_B075R8BXXC", Sys.Date(), ".RDS"))

