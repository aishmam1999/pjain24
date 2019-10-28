#!/bin/bash

#_=''

if [ $# -ne 6 ]
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
	echo "Provide valid Key-name"
	exit 1
fi


if [ -z $3 ]
then
	echo "Provide valid Security-Group"
	exit 1
fi


if [ -z $4 ]
then
    echo "Provide Instance Count"
	exit 1
fi


if [ -z $5 ]
then
	echo "Provide valid ELB-name"
	exit 1
fi


if [ -z $6 ]
then
	echo "Provide valid S3-bucket-name"
	exit 1
fi

############

#Create EC2 Instance

#aws ec2 run-instances --image-id ami-0eb7af7225499cc83 --count 1 --user-data file://installenv.sh --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-073198418b7ed762d

InstanceIdList=`aws ec2 run-instances --image-id $1 --count $4 --instance-type t2.micro --key-name $2 --security-groups $3 --placement AvailabilityZone=us-west-2b --user-data "file://./create-env-mp1.sh" --query 'Instances[*].InstanceId' --output text` 

# if [ "$?" -ne "0" ]
# then
# 	echo "Terminate Script"
# 	exit 1;
# fi
aws ec2 wait instance-status-ok
