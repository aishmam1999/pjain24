#!/bin/bash

echo "Image ID :" $1
echo "count :" $2
echo "Instance type :" $3
echo "KeyPair Name :" $4
echo "Securtiy Group ID :" $5


aws ec2 run-instances \
    --image-id $1 \
    --count $2 \
    --instance-type $3 \
    --key-name $4 \
    --user-data file://install.sh \
    --security-group-ids $5

aws ec2 authorize-security-group-ingress \
    --group-id $5 \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0