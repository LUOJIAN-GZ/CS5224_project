import json
import pymysql
import math
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)
host = "cs5224-database-1.cr5mtmxglepy.ap-southeast-1.rds.amazonaws.com"
user = "admin"
password = "hou12334566"
database = 'cs5224_formal'

def distance(lat1, lon1, lat2, lon2):
    # Calculate distance between two points on Earth's surface
    R = 6371  # Earth's radius in kilometers
    dLat = math.radians(lat2 - lat1)
    dLon = math.radians(lon2 - lon1)
    a = math.sin(dLat / 2) * math.sin(dLat / 2) + math.cos(math.radians(lat1)) \
        * math.cos(math.radians(lat2)) * math.sin(dLon / 2) * math.sin(dLon / 2)
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return R * c


def lambda_handler(event, context):
    # Retrieve user location from query parameters
    params = event
    lat=0
    lon=0
    distance_km=0
    
    flag_location = int(params['flag_location'])
    
    if flag_location == 1:
        lat = float(params['latitude'])
        lon = float(params['longitude'])
        distance_km = int(params['distance'])
    
    # Connect to MySQL database
    conn = pymysql.connect(host=host, user=user, password=password, database=database)
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    # Retrieve attractions within a certain distance from user location or all attractions
    if flag_location:
        query = f"SELECT * FROM attractions_all"
        cursor.execute(query)
        attractions = []
        for row in cursor.fetchall():
            dist_km = distance(lat, lon, row['latitude'], row['longitude'])
            if dist_km <= distance_km:
                attractions.append(row)
    else:
        query = f"SELECT * FROM attractions_all"
        cursor.execute(query)
        attractions = []
        for row in cursor.fetchall():
            attractions.append(row)
            log_name = row['name']
            logger.info(f"appended name={log_name}" )

    # Sort attractions by orderby parameter
    orderby = int(params['orderby'])
    if orderby == 0:
        attractions.sort(key=lambda x: x['twitter_trending_score'] or 0, reverse=True)
    else:
        attractions.sort(key=lambda x: x['rating'] or 0, reverse=True)

    # Return top 5 attractions
    top_attractions = attractions[:5]
    

    # Format response to match API definition
    response_body = []
    for attraction in top_attractions:
        response_body.append({
            'id': attraction['id'],
            'name': attraction['name'],
            'image_path': attraction['image_path'],
            'meta_descr': attraction['meta_descr'],
            'rating': attraction['rating'],
            'influence_score': attraction['twitter_trending_score'],
            #'twitter_posts': json.loads(attraction['hot_tweets']) if attraction['hot_tweets'] else []
        })

    conn.close()
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': response_body
    }
