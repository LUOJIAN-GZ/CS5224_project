import boto3
import pandas as pd
import requests
import logging
import pymysql
import numpy as np
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):

    logger.info("Cronjob start")

    # Connect to the Amazon S3 service
    s3 = boto3.client("s3")
    
    logger.info("Retrieving .csv file")
    # Retrieve the tourist attraction data from the Amazon S3 bucket
    attractions_file = "tourism_without_geometry.csv"
    bucket_name = "cs5224staticdata"
    obj = s3.get_object(Bucket=bucket_name, Key=attractions_file)
    attractions_df = pd.read_csv(obj["Body"])
    attractions_df.rename(columns={'PAGETITLE': 'NAME'}, inplace=True)
    logger.info("Retrieving .csv file succeed")
    
    #logger.info(f"An example line: {attractions_df[0]}")

    
    
    # Store the updated data in the database
    host = "cs5224-database-1.cr5mtmxglepy.ap-southeast-1.rds.amazonaws.com"
    port = 3306
    dbname = "cs5224_formal"
    user = "admin"
    password = "hou12334566"
    conn = pymysql.connect(host=host, port=port, user=user, password=password, db=dbname)
    cursor = conn.cursor()
    for index, row in attractions_df.iterrows():
        id = row["OBJECTID"]
        name = row["NAME"]
        address = row["ADDRESS"]
        if pd.isnull(address):
            address = ""
        latitude = row["LATITUDE"]
        longitude = row["LONGTITUDE"]
        image_path = row["IMAGE_PATH"]
        if pd.isnull(image_path):
            image_path = ""
        meta_descr = row["META_DESCR"]
        if pd.isnull(meta_descr):
            meta_descr = ""
        opening_hours = row["OPENING_HO"]
        if pd.isnull(opening_hours):
            opening_hours = ""
        
        
        logger.info(f"trying to store id= {id}, name={name}, address={address}, latitude={latitude}, longitude={longitude}, image_path={image_path}, meta_descr={meta_descr}, opening_hours={opening_hours}")
        # Check if the data already exists in the database
        query = "SELECT * FROM attractions WHERE id = %s"
        cursor.execute(query, (id))
        result = cursor.fetchone()
        
        # If the data exists, update the record
        if result:
            query = "UPDATE attractions SET name=%s, address=%s, latitude=%s, longitude=%s,\
                image_path=%s, meta_descr=%s, opening_hours=%s WHERE id=%s"
            cursor.execute(query, (name, address, latitude, longitude, 
                image_path, meta_descr, opening_hours, id))
        
        # If the data does not exist, insert a new record
        else:
            query = "INSERT INTO attractions (id, name, address, latitude, longitude, \
                image_path, meta_descr, opening_hours) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
            cursor.execute(query, (id,name, address, latitude, longitude, 
                image_path, meta_descr, opening_hours))
                
        logger.info(f"stored id={id}, name={name}, address={address}, latitude={latitude}, longitude={longitude}, image_path={image_path}, meta_descr={meta_descr}, opening_hours={opening_hours}")
        
    conn.commit()
    cursor.close() 
    conn.close()