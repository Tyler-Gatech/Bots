# Bot to web scrape Amazon

The purpose of this code is to web scrape reviews and customer profiles on Amazon to assist  [Lovevery's](https://www.amazon.com/Lovevery-Developmental-Sensory-Development-Grounded/dp/B075R8BXXC)  understanding of what else their customers purchase. When reviewing customer profiles on Amazon.com, for example [this customer's profile](https://www.amazon.com/gp/profile/amzn1.account.AGWNZI27Z372PBORQZNGEBDWOJHQ/ref=cm_cr_dp_d_gw_tr?ie=UTF8) you can observe that their reviews dynamically load as you scroll down on the page. This dynamic web page loading makes it necessary to use a bot and to load the data before scraping.

## Web Scraping Customer Reviews on Amazon

Please see the webscraping file to better understand how I looped through each review page on the products page to gather reviews from Amazon and build a list of customers and a database of their reviews. 

## Bot Automation on Amazon

Please see the bot file to learn how I automate dynamic pages and scrape all reviews left by customers