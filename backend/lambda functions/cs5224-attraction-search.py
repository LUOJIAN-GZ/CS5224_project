import json
import pymysql
import urllib.parse

host = "cs5224-database-1.cr5mtmxglepy.ap-southeast-1.rds.amazonaws.com"
user = "admin"
password = "hou12334566"
database = 'cs5224_formal'

def lambda_handler(event, context):
    # Retrieve search keyword from query parameters
    keyword = event['keyword']
    #keyword = event['keyword']
    keyword = urllib.parse.unquote(keyword)
    # Connect to MySQL database
    conn = pymysql.connect(host=host, user=user, password=password, database=database)
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    # Search for attractions containing the given keyword in their name or address
    query = f"SELECT * FROM attractions_all WHERE name LIKE '%{keyword}%' OR address LIKE '%{keyword}%'"
    cursor.execute(query)
    rows = cursor.fetchall()

    # Format response to match API definition
    response_body = []
    for row in rows:
        response_body.append({
            'id': row['id'],
            'name': row['name'],
            'image_path': row['image_path'],
            'meta_descr': row['meta_descr'],
            'rating': row['rating'],
            'influence_score': row['twitter_trending_score'],
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
