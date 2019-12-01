from boto3.dynamodb.conditions import Key, Attr


dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
table = dynamodb.Table('RecordsPal')
#response = table.put_item(Item={ 'S3finishedurl': {'S':url}})
response = table.query(
            KeyConditionExpression=Key('Receipt').eq("5de30aea7239e")
            )
email = response['Items'][0]['Email'];
receipt = "5de30aea7239e"


try:
    table.update_item(
        Key={
        'Receipt': receipt,
        'Email': email
        },
        UpdateExpression='SET S3finishedurl = :val1',
        ExpressionAttributeValues={
        ':val1': "chala chala222222222"
        })
except Exception as e:
    print (e)