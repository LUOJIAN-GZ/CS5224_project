import json
import pymysql
import math

host = "cs5224-database-1.cr5mtmxglepy.ap-southeast-1.rds.amazonaws.com"
user = "admin"
password = "hou12334566"
database = 'cs5224_formal'

def lambda_handler(event, context):
    # Retrieve user location from query parameters
    attraction_id = event["id"]

    # Connect to MySQL database
    conn = pymysql.connect(host=host, user=user, password=password, database=database)
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    # Retrieve attraction with given id
    query = f"SELECT * FROM attractions_all WHERE id = {attraction_id}"
    cursor.execute(query)
    row = cursor.fetchone()
    
    # Raise error if no rows are returned
    if row is None:
        raise ValueError(f"No attraction found with id {attraction_id}")

    
    # Format response to match API definition
    response_body = {
        'id': row['id'],
        'name': row['name'],
        'address': row['address'],
        'latitude': row['latitude'],
        'longitude': row['longitude'],
        'rating': row['rating'],
        'image_path': row['image_path'],
        'meta_descr': row['meta_descr'],
        'opening_hours': row['opening_hours'],
        'influence_score': row['twitter_trending_score'],
        'twitter_posts': json.loads(row['hot_tweets']) if row['hot_tweets'] else [],
    }

    conn.close()
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': response_body
    }