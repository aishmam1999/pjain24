import boto3
import os
import sys
import uuid
from urllib.parse import unquote_plus
from PIL import Image
from boto3.dynamodb.conditions import Key, Attr
import PIL.Image
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client('s3')

def resize_image(image_path, resized_path):
    with Image.open(image_path) as image:
        image.thumbnail(tuple(x / 2 for x in image.size))
        image.save(resized_path)

def handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key1 =unquote_plus(record['s3']['object']['key'])
        logger.info(key1)

        splitRecipit = key1.split('-')
        Receipt1 = splitRecipit[0]
        key =splitRecipit[1]
        logger.info(Receipt1)
        logger.info(key)
        download_path = '/tmp/{}{}'.format(uuid.uuid4(), key)
        upload_path = '/tmp/resized-{}'.format(key)
        s3_client.download_file(bucket, key, download_path)
        resize_image(download_path, upload_path)
        logger.info("resizeImage Finishe")
        logger.info(download_path)
        logger.info(upload_path)

        s3_client.upload_file(upload_path, '{}resized'.format(bucket), key)
        # url =  http://s3-REGION-.amazonaws.com/BUCKET-NAME/KEY
        
        url = "https://pal-544-raw-bucketresized.s3.amazonaws.com/"+key 
        dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
        table = dynamodb.Table('RecordsPal')
        response = table.query(
            KeyConditionExpression=Key('Receipt').eq(Receipt1)
            )
        logger.info(response)
        email = response['Items'][0]['Email']
        logger.info(email)

        receipt = "5de30aea7239e" 
        table.update_item(
        Key={
        'Receipt': receipt,
        'Email': email
        },
        UpdateExpression='SET S3finishedurl = :val1',
        ExpressionAttributeValues={
        ':val1': url
        }) 
        logger.info("table is updated")
        client = boto3.client('sns')
        response=client.publish(
        PhoneNumber = '+13126786501',
        Message="URL to Processed Image is" + key)




