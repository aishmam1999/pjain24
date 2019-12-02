#!/bin/bash
if [ $# -ne 8 ]
then

	echo "Provide only 8 positional parameters"
	exit 1

fi

if [ -z $1 ]
then
	echo "Provide valid Image-id"
	exit 1
fi


if [ -z $2 ]
then
	echo "Provide Instance count"
	exit 1
fi


if [ -z $3 ]
then
	echo "Provide Instance Type"
	exit 1
fi


if [ -z $4 ]
then
    echo "Provide KeyPair"
	exit 1
fi


if [ -z $5 ]
then
	echo "Provide valid Security Group ID"
	exit 1
fi


if [ -z $6 ]
then
	echo "Provide valid IAM profile/Role"
	exit 1
fi
if [ -z $7 ]
then
	echo "Provide valid subnet id"
	exit 1
fi
if [ -z $8 ]
then
	echo "Lamda ARN"
	exit 1
	#arn:aws:iam::382601412591:role/service-role/Class-2019
fi

############


sudo apt-get install ntpdate
sudo ntpdate 0.amazon.pool.ntp.org 
#Create EC2 Instance


sudo apt-get install ntpdate
sudo ntpdate 0.amazon.pool.ntp.org                                                                                                        
echo "***********************************Running the EC2 instances**********************************************"
#run ec2 instances
aws ec2 run-instances --image-id $1 --count $2 --instance-type $3 --key-name $4 --user-data file://install-app-env-front-end.sh --security-group-ids $5 --iam-instance-profile Name=$6 --subnet-id $7
#wait till instances are in running state
 
aws ec2 wait instance-status-ok

echo "***************************************EC2 Instances Deployed**************************************************************"

#get the instance ids of the running instances
MYID=`aws ec2 describe-instances --query 'Reservations[].Instances[].[State.Name, InstanceId]' --output text | grep running | awk '{print $2}'`                                                                                                                                
echo "********************************************Creating load balancer*************************************************************"

#create load balancer
aws elb create-load-balancer --load-balancer-name pjain24-load-balancer --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --subnets $7 
#aws elb create-load-balancer --load-balancer-name pjain24-load-balancer --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --subnets subnet-8f3249b1

echo " ****************************************creating cookie policy**************************************************************************"
#create cookie policy
aws elb create-lb-cookie-stickiness-policy --load-balancer-name pjain24-load-balancer --policy-name my-duration-cookie-policy
#register ec2 instances with load balancer

echo "****************************************** Register instance to load balancer ************************************************************"
aws elb register-instances-with-load-balancer --load-balancer-name pjain24-load-balancer --instances $MYID

echo "******************************************* Waiting to Register instance to load balancer ************************************************"
aws elb wait any-instance-in-service --load-balancer-name pjain24-load-balancer --instances $MYID

echo "********************************************** create SQS-topic ***************************************************"
aws sqs create-queue --queue-name inclass-pjain
aws sns create-topic --name project-messages-pjain
#aws dynamodb create-table --table-name RecordsPal --attribute-definitions AttributeName=Receipt,AttributeType=S AttributeName=Email,AttributeType=S --key-schema AttributeName=Receipt,KeyType=HASH AttributeName=Email,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

echo "*************************************************** Auto-Consoling group ****************************************************"

#Creating Auto Scaling Group
#Create Launch Configuration
echo "Creating launch configurations"

aws autoscaling create-launch-configuration --launch-configuration-name pjain-mp2-launch-config --key-name $4 --image-id $1 --security-groups $5 --instance-type t2.micro --user-data "file://./install-app-env-front-end.sh" --iam-instance-profile $6 --block-device-mappings "[{\"DeviceName\": \"/dev/xvdh\",\"Ebs\":{\"VolumeSize\":10}}]"
echo "Creating auto scaling group"
aws autoscaling create-auto-scaling-group --auto-scaling-group-name pjain-mp2-auto-scaling --launch-configuration-name pjain-mp2-launch-config --load-balancer-names pjain24-load-balancer --health-check-type ELB --health-check-grace-period 120 --min-size 2 --max-size 6 --desired-capacity 3 --default-cooldown 300 --availability-zones us-east-1a
echo "autoscaling group created "
#attaching loadbalancer to autoscaling 
echo "**********************************************Performing health check***************************************************************"
#health check
aws elb configure-health-check --load-balancer-name pjain24-load-balancer --health-check Target=HTTP:80/png,Interval=30,UnhealthyThreshold=2,HealthyThreshold=2,Timeout=3


#./create-env.sh $1= ami-0eb7af7225499cc83 $2=1 $3=t2.micro $4=MyKeyPair $5=sg-073198418b7ed762d $6=Inclass-2019 $7= subnet-8f3249b1
#aws autoscaling create-launch-configuration --launch-configuration-name pjain-mp2-launch-config --key-name MyKeyPair --image-id ami-0eb7af7225499cc83 --security-groups sg-073198418b7ed762d --instance-type t2.micro --user-data "file://./install-app-env-front-end.sh" --iam-instance-profile Inclass-2019 --block-device-mappings "[{\"DeviceName\": \"/dev/xvdh\",\"Ebs\":{\"VolumeSize\":10}}]"
echo "********************************************** creating Dynamodb***************************************************************"

aws dynamodb create-table --table-name RecordsPal --attribute-definitions AttributeName=Receipt,AttributeType=S AttributeName=Email,AttributeType=S --key-schema AttributeName=Receipt,KeyType=HASH AttributeName=Email,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
aws dynamodb describe-table --table-name RecordsPal


echo "********************************************** creating Lamdba Fucntion***************************************************************"

#arn:aws:iam::382601412591:role/service-role/Class-2019
aws lambda create-function --function-name pal-function --zip-file fileb://function.zip --handler process.handler --runtime python3.6 --role $8 #arn:aws:iam::382601412591:role/service-role/Class-2019
aws lambda add-permission --function-name pal-function --action lambda:InvokeFunction --statement-id 1 --principal s3.amazonaws.com

lambda=`aws lambda list-functions --query 'Functions[*].FunctionArn' --output text`
aws s3api put-bucket-notification-configuration --bucket "pal-544-raw-bucket" --notification-configuration '{"LambdaFunctionConfigurations": [{"LambdaFunctionArn": "'$lambda'","Events": ["s3:ObjectCreated:*"]}]}'  