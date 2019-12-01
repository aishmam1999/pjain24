import boto3

dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
table = dynamodb.Table('RecordsPal')
        #response = table.put_item(Item={ 'S3finishedurl': {'S':url}})
table.update_item(
        Key={
        'Receipt': Receipt,
        },
        UpdateExpression='SET S3finishedurl = :val1',
        ExpressionAttributeValues={
          ':val1': "chala chala",
        }