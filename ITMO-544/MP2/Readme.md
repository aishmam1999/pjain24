# Done By : Palash Jain
# MidTerm Project 2

# Make Sure
## AMI image - ami-0eb7af7225499cc83 
## NOTE : If submit page or anything doesn't appear , please restart apache2

## My Project has Two Part 1> FrontEnd 2> Backend

## Frontend 
#### Frontend has three file Index.php gallery.php and Submit.php
#### Index.php has two part Submit (Name, Emailid , Image and Phone Number)  and Show Galary
#### Submit File pushes orignal Image and Modified Image to s3 bucket 
#### Gallery Displays both ORignal as well as Modified Image  

## Backend

#### install-app-front-env.sh : install all Requirements needed for Project add composer 
#### create-env.sh :  is used to create ec2-instace , loadbalancer, RDS etc 
#### destory create ec2-instance , loadbalacer ,Dynamodb etc 
#### Lambda funtion to process image and update dynamo db
#### User will recive SMS after image get processed

# All the givien requairent should be full-filled before getting output