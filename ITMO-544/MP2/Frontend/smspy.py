import boto3

client = boto3.client("SNS")
client.publish(PhoneNumber = "+1 312 678 6501", Message="Testing masg from py code")