
# Load libraries. - You may have to install the "needs" package via install.packages("needs")

library(needs)
needs(rtweet, tidyverse)

# Authenticate with Twitter's API

# Create token
tw_token <- create_token(
  app = app,
  consumer_key = consumer_key,
  consumer_secret = consumer_secret,
  access_token = access_token,
  access_secret = access_secret,
  set_renv = FALSE)


# Input for rtweet functions

user_name = "your-twitter-handle"





# get timeline

tl <- get_timeline(user = user_name, n = 3200, max_id = NULL,
             home = FALSE, parse = TRUE, check = TRUE, token = tw_token)

# filter tweets older than three month

threeMonthsAgo <- seq(as.Date(max(tl$created_at)), length = 2, by = "-3 months")[2]

tweets_to_delete <- tl %>% 
  filter(created_at <= threeMonthsAgo)

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

favs <- get_favorites(user = user_name,n = 3200,since_id = NULL,max_id = NULL,parse = TRUE,token = NULL)

# filter favs older than three month

threeMonthsAgo <- seq(as.Date(max(favs$created_at)), length = 2, by = "-3 months")[2]

favs_to_delete <- favs %>% 
  filter(created_at <= threeMonthsAgo)



# delete old favs

favsIds <- favs_to_delete$status_id

for (i in 1:length(favsIds)) {
  
  post_tweet(status = NULL, media = NULL,
             token = tw_token, in_reply_to_status_id = NULL, destroy_id = paste(favsIds[i]),
             retweet_id = NULL, auto_populate_reply_metadata = FALSE)
  
  print(i)
}




