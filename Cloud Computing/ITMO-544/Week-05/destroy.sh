#!/bin/bash



inst=$(aws ec2 describe-instances     --query 'Reservations[*].Instances[*].{Instance:InstanceId}')
aws ec2 terminate-instances --instance-ids $inst