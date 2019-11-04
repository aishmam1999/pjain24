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

		if [ ! -z "$InstanceIdList" ]
		then
			echo "Deregister instances from load balancer"
			tempVar=`aws elb deregister-instances-from-load-balancer --load-balancer-name ${arrLoadBalancerList[$i-1]} --instances $InstanceIdList`
			
			if [ "$?" -ne "0" ]
			then
				echo "Terminate Script"
				exit 1;
			fi
			
			echo "Instances deregistered"
			
		fi

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

#Delete RDS

rdsval=`aws rds describe-db-instances --db-instance-identifier pjain24-instance`

if [ "$?" -ne "0" ]
then
	echo "No RDS to delete"
else

	if [ ! -z "$rdsval" ]
	then
		
		aws rds delete-db-instance --db-instance-identifier pjain24-instance-db-read --skip-final-snapshot >/dev/null 2>&1
		
		if [ "$?" -ne "0" ]
		then
			echo "Either RDS Read Reaplica is being deleted or pending. Try again in a while."
		else
			echo "RDS Read Replica Delete initiated"
		fi
		
		aws rds delete-db-instance --db-instance-identifier pjain24-instance-db --skip-final-snapshot >/dev/null 2>&1
		
		if [ "$?" -ne "0" ]
		then
			echo "Either RDS is being deleted or pending. Try again in a while."
		else
			echo "RDS Delete initiated"
		fi			
	

	else

		echo "No RDS to delete"
	
	fi
	
fi



