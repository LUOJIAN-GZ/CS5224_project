# Twitter Data Processing Lambda Function

This Lambda function processes Twitter data for a list of attractions, calculates the influence scores of tweets, and computes the trending score for each attraction. The processed data is then inserted into a MySQL database.

## Prerequisites

- Python 3.8 or higher
- AWS account with Lambda service and MySQL RDS instance, NAT enabled to access internet
- Twitter Developer account with API credentials

## Setup

1. Clone the repository.

2. Install the required Python packages:

   ```bash
   pip install -r twitter/requirements.txt
   ```
   

3. Set up the following environment variables for your Lambda function:
    ```
    CONSUMER_KEY: Twitter API consumer key
    CONSUMER_SECRET: Twitter API consumer secret
    ACCESS_TOKEN: Twitter API access token
    ACCESS_TOKEN_SECRET: Twitter API access token secret
    MYSQL_HOST: MySQL database host
    MYSQL_USER: MySQL database user
    MYSQL_PASSWORD: MySQL database password
    MYSQL_DB: MySQL database name
    TABLE_NAME: MySQL table name to store the processed data
    INPUT_FILE: CSV file containing the list of attractions
    ```
4. Deploy the Lambda function:

    To deploy the Lambda function, you need to create a zip file containing the lambda_function.py script and all the required packages. Run the following command in your terminal:
    ```
    pip install -r twitter/requirements.txt -t twitter/
    cd twitter
    zip -r lambda_function.zip .
    ```
    Now you can upload the lambda_function.zip file to your Lambda function in the AWS console.
    
    Configure an EventBridge (CloudWatch Events) trigger for the Lambda function to schedule the execution.

## Usage
The Lambda function will be triggered automatically based on the configured EventBridge schedule. The processed Twitter data will be inserted into the specified MySQL table.
