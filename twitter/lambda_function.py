import tweepy
import datetime
import time
import pytz
import json
import csv
import os
import pymysql

# Set up Twitter API credentials
consumer_key = os.environ['CONSUMER_KEY']
consumer_secret = os.environ['CONSUMER_SECRET']
access_token = os.environ['ACCESS_TOKEN']
access_token_secret = os.environ['ACCESS_TOKEN_SECRET']

# Set up MySQL credentials
mysql_host = os.environ['MYSQL_HOST']
mysql_user = os.environ['MYSQL_USER']
mysql_password = os.environ['MYSQL_PASSWORD']
mysql_db = os.environ['MYSQL_DB']

# Set up other info
output_table = os.environ['TABLE_NAME']
input_file = os.environ['INPUT_FILE']

# Set up Tweepy
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth)
# automatically wait and handle rate limits when they are reached
# api = tweepy.API(auth, wait_on_rate_limit=True)



def get_tweets(search_query, max_tweets=200, recency_weight=1.0):
    tweets = []
    utc = pytz.UTC
    end_date = datetime.datetime.now(utc) - datetime.timedelta(days=180)
    now = datetime.datetime.now(utc)

    for tweet in tweepy.Cursor(api.search_tweets, q=search_query, tweet_mode="extended", since_id=None).items(max_tweets):
        if tweet.created_at < end_date:
            break

        time_diff = now - tweet.created_at
        days_diff = time_diff.days + (time_diff.seconds / 86400)
        recency_factor = 1 / (1 + days_diff) ** recency_weight

        influence_score = ((20 * tweet.retweet_count) + (200 * tweet.favorite_count) + (1 * tweet.user.followers_count)) * recency_factor

        tweet_data = {
            "url": f"https://twitter.com/{tweet.user.screen_name}/status/{tweet.id}",
            "text": tweet.full_text,
            "created_at": tweet.created_at.isoformat(),
            "likes": tweet.favorite_count,
            "retweets": tweet.retweet_count,
            "followers": tweet.user.followers_count,
            "influence_score": influence_score
        }
        tweets.append(tweet_data)

    return tweets


def get_trending_score(tweets):
    total_score = 0
    for tweet in tweets:
        total_score += tweet["influence_score"]

    return total_score


def insert_into_database(attraction_rankings):
    connection = pymysql.connect(host=mysql_host,
                                 user=mysql_user,
                                 password=mysql_password,
                                 database=mysql_db,
                                 cursorclass=pymysql.cursors.DictCursor)
    try:
        with connection.cursor() as cursor:
            for attraction in attraction_rankings:
                sql = f"""REPLACE INTO {mysql_db}.{output_table}
                         (id, dt, other_names, hot_tweets, twitter_trending_score)
                         VALUES (%s, %s, %s, %s, %s)"""
                cursor.execute(sql, (attraction['object_id'],
                                     datetime.datetime.now().strftime('%Y-%m-%d'),
                                     json.dumps(attraction['other_names']),
                                     json.dumps(attraction['tweets']),
                                     attraction['trending_score']))
        connection.commit()
    finally:
        connection.close()


def lambda_handler(event, context):
    attraction_rankings = []

    with open(input_file, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)

        # att_ls = ["Gardens by the Bay", "Universal Studio Singapore", "Resorts World Sentosa", "National Museum of Singapore"]
        for i, row in enumerate(reader):

            object_id = int(row['OBJECTID'])
            other_names = [row['PAGETITLE']] + row['ATT_NAMES_PROC'].split('|')

            # Combine the names with an OR operator for the search query
            search_query = " OR ".join([f"\"{name}\"" for name in other_names])

            # Add retweet filter to the search query
            search_query = f"{search_query} -filter:retweets"

            tweets = get_tweets(search_query)

            sorted_tweets = sorted(tweets, key=lambda x: x["influence_score"], reverse=True)
            if len(sorted_tweets) >= 20:
                top_20_tweets = sorted_tweets[:20]
            else:
                top_20_tweets = sorted_tweets

            trending_score = get_trending_score(top_20_tweets)

            attraction_rankings.append({
                "object_id": object_id,
                "other_names": other_names,
                "trending_score": trending_score,
                "tweets": top_20_tweets
            })
    print(f"done the processing for id-{object_id} attraction{other_names[0]}")
    attraction_rankings.sort(key=lambda x: x["trending_score"], reverse=True)

    # Insert the data into the MySQL database
    insert_into_database(attraction_rankings)

    return {
        'statusCode': 200,
        'body': attraction_rankings
    }

