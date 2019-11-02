#!/bin/bash

#_=''

if [ $# -ne 7 ]
then

	echo "Provide only six positional parameters"
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

############


#Create EC2 Instance

sudo apt-get install ntpdate
sudo ntpdate 0.amazon.pool.ntp.org                                                                                                        
echo "***********************************Running the EC2 instances**********************************************"
echo "----------------------------------------------------------"
#run ec2 instances
aws ec2 run-instances --image-id $1 --count $2 --instance-type $3 --key-name $4 --user-data file://install-env.sh --security-group-ids $5 --iam-instance-profile Name=$6 --subnet-id $7
#wait till instances are in running state
echo "*********************************waiting for instance status okay*******************************************************"
echo "----------------------------------------------------------"

aws ec2 wait instance-status-ok

echo ""
echo "***************************************EC2 Instances Deployed**************************************************************"
echo "----------------------------------------------------------"

#get the instance ids of the running instances
MYID=`aws ec2 describe-instances --query 'Reservations[].Instances[].[State.Name, InstanceId]' --output text | grep running | awk '{print $2}'`                                                                                                                                
echo "********************************************Creating load balancer*************************************************************"
echo "----------------------------------------------------------"

#create load balancer
aws elb create-load-balancer --load-balancer-name pjain24-load-balancer --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --subnets $7
#aws elb create-load-balancer --load-balancer-name pjain24-load-balancer --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --subnets subnet-8f3249b1

echo "**********************************************Performing health check***************************************************************"
echo "----------------------------------------------------------"
#health check
aws elb configure-health-check --load-balancer-name pjain24-load-balancer --health-check Target=HTTP:80/png,Interval=30,UnhealthyThreshold=2,HealthyThreshold=2,Timeout=3

echo " ****************************************creating cookie policy**************************************************************************"
echo "----------------------------------------------------------"
#create cookie policy
aws elb create-lb-cookie-stickiness-policy --load-balancer-name pjain24-load-balancer --policy-name my-duration-cookie-policy
#register ec2 instances with load balancer

echo "****************************************** Register instance to load balancer ************************************************************"
echo "----------------------------------------------------------"
aws elb register-instances-with-load-balancer --load-balancer-name pjain24-load-balancer --instances $MYID

echo "******************************************* Waiting to Register instance to load balancer ************************************************"
echo "----------------------------------------------------------"
#wait for instances to be registered
aws elb wait any-instance-in-service --load-balancer-name pjain24-load-balancer --instances $MYID

echo "********************************************** Finished registering target instances ***************************************************"
echo "----------------------------------------------------------"
echo "*********************************************** Creating DB - instance ****************************************************************"
echo "----------------------------------------------------------"
#create db instance
aws rds create-db-instance --allocated-storage 20 --db-instance-class db.t2.micro --db-instance-identifier pjain24-instance --engine mysql --master-username master --master-user-password p4ssw0rd

echo "**************************************************** Created RDS instance **********************************************************************"
echo "----------------------------------------------------------"
echo "*************************************************** wait for DB - instance to be available ****************************************************"
echo "----------------------------------------------------------"
# wait for DB instace avaibility 
aws rds db-instance-available --db-instance-identifier pjain24-instance
#connect to sql
mysql --host=pjain24-instance.cvs4vczdbufc.us-east-1.rds.amazonaws.com -u master -pp4ssw0rd 

