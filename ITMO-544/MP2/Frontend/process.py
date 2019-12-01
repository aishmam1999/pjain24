import boto3
import os
import sys
import uuid
from urllib.parse import unquote_plus
from PIL import Image
import PIL.Image

s3_client = boto3.client('s3')

def resize_image(image_path, resized_path):
    with Image.open(image_path) as image:
        image.thumbnail(tuple(x / 2 for x in image.size))
        image.save(resized_path)

def handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key1 =unquote_plus(record['s3']['object']['key'])
        splitRecipit = key1.split('-')
        Receipt = splitRecipit[0]
        key =splitRecipit[1]
        download_path = '/tmp/{}{}'.format(uuid.uuid4(), key)
        upload_path = '/tmp/resized-{}'.format(key)
        s3_client.download_file(bucket, key, download_path)
        resize_image(download_path, upload_path)
        s3_client.upload_file(upload_path, '{}resized'.format(bucket), key)
        # url =  http://s3-REGION-.amazonaws.com/BUCKET-NAME/KEY
        
        url = "https://pal-544-raw-bucketresized.s3.amazonaws.com/"+key 
        dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
        table = dynamodb.Table('RecordsPal')
        #response = table.put_item(Item={ 'S3finishedurl': {'S':url}})
        table.update_item(
        Key={
        'Receipt': Receipt,
        },
        UpdateExpression='SET S3finishedurl = :val1',
        ExpressionAttributeValues={
          ':val1': url
        }
)




        client = boto3.client('sns')
        response=client.publish(
        PhoneNumber = '+13126786501',
        Message="URL to Processed Image is" + key)




