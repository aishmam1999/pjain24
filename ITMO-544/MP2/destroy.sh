loadBalancerList=`aws elb describe-load-balancers --query 'LoadBalancerDescriptions[*].LoadBalancerName' --output text`

if [ "$?" -ne "0" ]
then
	echo "Terminate Script"
	exit 1;
fi

if [ ! -z "$loadBalancerList" ]
then

	declare -a arrLoadBalancerList=(${loadBalancerList})
	# get length of an arrLoadBalancerList
	arrLoadBalancerListLength=${#arrLoadBalancerList[@]}
	
	for (( i=1; i<${arrLoadBalancerListLength}+1; i++ ));
	do	

		#Getting Load balancer instances

		InstanceIdList=`aws elb describe-load-balancers --load-balancer-name ${arrLoadBalancerList[$i-1]} --query 'LoadBalancerDescriptions[*].Instances' --output text`

		if [ "$?" -ne "0" ]
		then
			echo "Terminate Script"
			exit 1;
		fi

		echo "$InstanceIdList"

		############

		#Deregister Load Balancers instances

		# if [ ! -z "$InstanceIdList" ]
		# then
		# 	echo "Deregister instances from load balancer"
		# 	tempVar=`aws elb deregister-instances-from-load-balancer --load-balancer-name ${arrLoadBalancerList[$i-1]} --instances $InstanceIdList`
			
		# 	if [ "$?" -ne "0" ]
		# 	then
		# 		echo "Terminate Script"
		# 		exit 1;
		# 	fi
			
		# 	echo "Instances deregistered"
			
		# fi

		############

		#Delete Load balancer

		echo "Delete load balancer"
		aws elb delete-load-balancer --load-balancer-name ${arrLoadBalancerList[$i-1]}

		if [ "$?" -ne "0" ]
		then
			echo "Terminate Script"
			exit 1;
		fi

		echo "Load balancer deleted"


		############

		#Delete Instances now


		if [ ! -z "$InstanceIdList" ]
		then
			echo "Terminating all instance."
			temploadbalinstance=`aws ec2 terminate-instances --instance-ids $InstanceIdList`
			
			if [ "$?" -ne "0" ]
			then
				echo "Terminate Script"
				exit 1;
			fi
			
			echo "Waiting for Instances to terminate"
			
			aws ec2 wait instance-terminated --instance-ids $InstanceIdList
			
			echo "All Instances Terminated"
		
		else
			
			echo "No instances to delete for Load balancer ${arrLoadBalancerList[$i-1]}"
			
		fi
	
	done

else
	
	echo "No Load Balancer to Delete"

fi
############

AllInstanceIdList=`aws ec2 describe-instances --filters '[{"Name": "instance-state-name","Values": ["pending", "running"] }]' --query 'Reservations[*].Instances[*].InstanceId' --output text`

if [ "$?" -ne "0" ]
then
	echo "Terminate Script"
	exit 1;
fi


if [ ! -z "$AllInstanceIdList" ]
then
	echo "Terminating other running instances"
	
	tempotherinstances=`aws ec2 terminate-instances --instance-ids $AllInstanceIdList`
	
	if [ "$?" -ne "0" ]
	then
		echo "Terminate Script"
		exit 1;
	fi	
	
	echo "Waiting for Instances to terminate"
	
	aws ec2 wait instance-terminated --instance-ids $AllInstanceIdList
	
	echo "All other Instances Terminated"
	
else

	echo "No Extra Instances running"

fi


############
echo "Deleting AutoScaling Configration"
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name pjain-mp2-auto-scaling --force-delete

echo "Deleting AutoScaling Group"

aws autoscaling delete-launch-configuration --launch-configuration-name pjain-mp2-launch-config

echo "Deleting Lambdafuntion"
aws lambda delete-function --function-name pal-function
echo "Deleting Table"

aws dynamodb delete-table --table-name RecordsPal
