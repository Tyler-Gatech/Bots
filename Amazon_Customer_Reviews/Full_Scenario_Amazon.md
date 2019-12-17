# The Scenario: What else do my customers purchase?

Imagine you work in the analytics department of a small company. The company has been wildly successful in selling their most recent product, "The Play Gym", via Amazon.com. The Play Gym is "everything your child needs in an activity gym-from batting to teething to learning to focus-for a whole year of play."

Now, your boss would like to know what else your customers purchase on Amazon to research new product ideas. So you login to your sql database, and query the information. Except, the database doesn't exist. You don't know what else your customers purchase, because they purchase products from other companies. 

## Initial Exploration
So you decide to go to the [product page](https://www.amazon.com/Lovevery-Developmental-Sensory-Development-Grounded/dp/B075R8BXXC) on Amazon.com and do some digging into the customer reviews. Quickly, you realize there are over 500 customer reviews. You click on one of the [customer's profile](https://www.amazon.com/gp/profile/amzn1.account.AGWNZI27Z372PBORQZNGEBDWOJHQ/ref=cm_cr_dp_d_gw_tr?ie=UTF8) to see what other products they have left reviews for. When you click on their profile, the page says they have left over 50 reviews. You do the match (500 customers * 50 reviews) and realize that is a lot of reviews to manually scan through. As a good data scientist you look to implement an automated solution. 


## Automated Solution 
You develop a 2-Step plan to build a good database for further customer analysis. 
1. Scrape all of the reviews from Amazon and gather a list of customer ids
2. Scrape through all the customer ids and gather a list of products purchased

## Web scraper
So you develop a relatively straight forward web scraper and are able to quickly compile a list of users who have left reviews for your product, and then you try looping throught he user list to see what other products they have reviewed. Except you hit a snag, the product reviews dynamically load as you scroll down. You can't webscape data that isn't loaded on a web page. 

## The Solution
You need a solution that allows you to scrape the web page information dynamically. In this case, you need to be able to scroll down on the user review page to allow more reviews to load. You decide to create a bot. The bot allows you to control an automated browser (e.g. chrome) and then can scrape the web page as new information loads. This allows you to see and scrape all the information on the web page, just as a human user would see, but obviously much faster. 



