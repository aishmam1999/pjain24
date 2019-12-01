import boto3

# client = boto3.client('SNS')
# client.publish(PhoneNumber = "+1 312 678 6501", Message="Testing masg from py code")
import boto3

dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
table = dynamodb.Table('RecordsPal')
#response = table.put_item(Item={ 'S3finishedurl': {'S':url}})
try:
    table.update_item(
        Key={
        'Receipt': Receipt,
        },
        UpdateExpression='SET S3finishedurl = :val1',
        ExpressionAttributeValues={
        ':val1': "chala chala"
        })
except Exception as e:
    print (e)