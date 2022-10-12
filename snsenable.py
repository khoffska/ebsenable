import boto3

AWS_REGION = 'eu-west-1'
session = boto3.Session(region_name=AWS_REGION)
sns = session.client('sns')
topic = client.list_topics()
def main(event, context):
    sns_regions = [region['RegionName'] for region in ssm.describe_regions()['Regions']]
    # For all AWS Regions
    for region in sns_regions:
        conn = boto3.client('sns', region_name=region)
        print ("Checking AWS Region: " + region)
        status = conn.get_topic_attributes(TopicArn= 'topic')
        print ("===="*10)
        result = status["EbsEncryptionByDefault"]
        if result == True:
            print ("Activated, nothing to do")
        else:
            print("Not activated, activation in progress")
            conn.enable_ebs_encryption_by_default()

if __name__ == '__main__':
    main(0,0)
