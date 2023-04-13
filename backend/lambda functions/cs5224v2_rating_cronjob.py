import boto3
import pandas as pd
import requests
import logging
import pymysql
import numpy as np
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def fetch_ratings(attractions_df, api_key):
    ratings = []
    for index, row in attractions_df.iterrows():
        name = row["NAME"]
        lat = row["LATITUDE"]
        lng = row["LONGITUDE"]
        url = f"https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input={name}&inputtype=textquery&fields=name,rating&locationbias=point:{lat},{lng}&key={api_key}"
        logger.info(f"Fetching...NAME={name}")
        try:
            response = requests.get(url).json()
        except requests.exceptions.HTTPError as errh:
            logger.info("Http Error:",errh)
        except requests.exceptions.ConnectionError as errc:
            logger.info("Error Connecting:",errc)
        except requests.exceptions.Timeout as errt:
            logger.info("Timeout Error:",errt)
        except requests.exceptions.RequestException as err:
            logger.info("OOps: Something Else",err)
        
        try:
            rating = response["candidates"][0]["rating"]
            logger.info(f"Fetch succeed, NAME={name}, rate={rating}")
        except:
            rating = None
            logger.info(f"Fetch faild, NAME={name}")
        ratings.append(rating)
    return ratings

def lambda_handler(event, context):
    # Retrieve the Google Maps API key from AWS Secrets Manager

    api_key ="AIzaSyDCMvaXvzWkDRE4XsSEz8_yHkjXlOLF0o0"
    
    # Retrieve the attractions data from RDS database
    host = "cs5224-database-1.cr5mtmxglepy.ap-southeast-1.rds.amazonaws.com"
    port = 3306
    dbname = "cs5224_formal"
    user = "admin"
    password = "hou12334566"
    conn = pymysql.connect(host=host, port=port, user=user, password=password, db=dbname)
    cursor = conn.cursor()
    query = "SELECT id, name, latitude, longitude FROM attractions"
    cursor.execute(query)
    attractions_data = cursor.fetchall()
    attractions_df = pd.DataFrame(attractions_data, columns=["ID", "NAME", "LATITUDE", "LONGITUDE"])
    
    # Fetch the ratings from Google Maps
    logger.info("Fetching ratings from Google Maps")
    ratings = fetch_ratings(attractions_df, api_key)
    attractions_df["RATING"] = ratings
    
    # Update the attraction_ratings table in RDS database
    logger.info("Updating the attraction_ratings table in RDS database")
    cursor = conn.cursor()
    for index, row in attractions_df.iterrows():
        id = row["ID"]
        rating = row["RATING"]
        if np.isnan(rating):
            rating = None
        query = "INSERT INTO attraction_ratings (id, rating) VALUES (%s, %s) ON DUPLICATE KEY UPDATE rating=%s"
        if rating is not None:
            cursor.execute(query, (id, rating, rating))
        else:
            logger.info(f"No rating found for attraction id={id}")

    conn.commit()
    cursor.close() 
    conn.close()

    logger.info("Cronjob complete")
    return {"status": "success"}
