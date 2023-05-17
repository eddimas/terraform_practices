import boto3

def lambda_handler(event, context):
    print ("This is a  testss")
    client = boto3.client("ec2", region_name="us-east-1")

    instance_id = client.describe_instances(
        Filters=[{"Name": "instance-id", "Values": ["$(curl -s http://169.254.169.254/latest/meta-data/instance-id)"]}]
    ).Reservations[0].Instances[0].InstanceId

    tags = client.describe_tags(Filters=[{"Name": "resource-id", "Values": [instance_id]}]).Tags

    for tag in tags:
        if tag.Key == "my-tag-name":
            print(tag.Value)

    return tag.Value