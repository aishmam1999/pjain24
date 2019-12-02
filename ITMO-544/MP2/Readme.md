# Done By : Palash Jain
# MidTerm Project 2

# Make Sure
## AMI image - ami-0eb7af7225499cc83 
## NOTE : If submit page or anything doesn't appear , please restart apache2
## NOTE: It might Take some time to Recieve MSG 
## NOTE : Funtion.zip contains dependencies and process.py(i.e Lamda function). Make sure it is available at same place from where create-env is executed 


## My Project has Two Part 1> FrontEnd 2> Backend

## Frontend 
#### Frontend has three file Index.php gallery.php and Submit.php
#### Index.php has two part Submit (Name, Emailid , Image and Phone Number)  and Show Galary
#### Submit File pushes orignal Image. and stores in s3 bucket . Which Triggers the lamda Function 
#### Gallery Displays both orignal as well as Modified Image  


| <img src="https://github.com/illinoistech-itm/pjain24/blob/master/ITMO-544/MP2/images/index.JPG" alt="" style="width: 400px;"/> |


## Backend

#### install-app-front-env.sh : install all Requirements needed for Project add composer 
#### create-env.sh :  is used to create ec2-instace , loadbalancer, Dynamodb etc 
#### destory create ec2-instance , loadbalacer ,Dynamodb etc 
#### Lambda funtion to process image, update dynamo db and sends SMS to Phone number 
#### User will recive SMS after image get processed

#### process.py : Contains code of lambda funtion (includes process image code and SNS code )

# All the givien requairent should be full-filled before getting output