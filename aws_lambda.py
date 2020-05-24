import os
import json
import boto3


arn_name = os.environ['ARN_NAME']
region = os.environ['REGION_NAME']
notif = os.environ['EVENT_NAME']
sns_subject = os.environ['SNS_SUBJECT']
sns_message = os.environ['SNS_MESSAGE']
jParsed = ''

def lambda_handler(event, context):
    records = event['Records']
    for sns in records:
        message = sns['Sns']['Message']
        if notif in message:
            newEvent = message
            jsonL = json.loads(newEvent)
            jParsed = jsonL[notif]
            
    sns = boto3.client('sns', region_name=region)
    sns.publish(
        TargetArn=arn_name,
        Subject=sns_subject,
        Message=(sns_message + jParsed)
    )
