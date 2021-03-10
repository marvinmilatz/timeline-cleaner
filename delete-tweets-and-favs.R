
### Load libraries - You may have to install the "needs" package via install.packages("needs")

library(needs)
needs(rtweet, tidyverse)

### Provide input variables

# Input for Twitter Authentication. You need a twitter dev account to get the following access credentials. You can apply here: https://developer.twitter.com/en/apply-for-access 

app <- "name-of-your-twitter-app"
consumer_key <- "your-consumer-key-provided-by-twitter"
consumer_secret <- "your-consumer-secret-provided-by-twitter"
access_token <- "your-access-token-provided-by-twitter"
access_secret <- "your-access-secret-provided-by-twitter"

# Input for tweet and fav cleaning

user_name <- "your-twitter-handle"

# Months worth of tweets you want to KEEP! Counted backwards from your most recent tweet

monthsToKeep <- "-3 months"

### Authenticate with Twitter's API

# Create token

tw_token <- create_token(
  app = app,
  consumer_key = consumer_key,
  consumer_secret = consumer_secret,
  access_token = access_token,
  access_secret = access_secret,
  set_renv = FALSE)

# Test token

rl <- rate_limit()

#by running the following line of code you should see different rate limits printed to your Console

print(rl)

### Delete Tweets

# get timeline

tl <- get_timeline(user = user_name, n = 3200, max_id = NULL,
             home = FALSE, parse = TRUE, check = TRUE, token = tw_token)

# filter tweets older than the month count you chose

filterDate <- seq(as.Date(max(tl$created_at)), length = 2, by = monthsToKeep)[2]

tweets_to_delete <- tl %>% 
  filter(created_at <= filterDate)

# delete old tweets

twIds <- tweets_to_delete$status_id

for (i in 1:length(twIds)) {
  
  post_tweet(status = NULL, media = NULL,
             token = tw_token, in_reply_to_status_id = NULL, destroy_id = paste(twIds[i]),
             retweet_id = NULL, auto_populate_reply_metadata = FALSE)
  
  print(i)
}

# delete old favourites

# get favs

favs <- get_favorites(user = user_name,n = 3000,since_id = NULL,max_id = NULL,parse = TRUE,token = NULL)

# filter favs older than three month

filterDate <- seq(as.Date(max(favs$created_at)), length = 2, by = monthsToKeep)[2]

favs_to_delete <- favs %>% 
  filter(created_at <= filterDate)

# delete old favs

favsIds <- favs_to_delete$status_id

for (i in 1:length(favsIds)) {

  post_favorite(status_id = paste(favsIds[i]), destroy = TRUE,
                include_entities = FALSE, token = NULL)
  
  print(i)
}
