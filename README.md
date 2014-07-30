## Getting Started
### Create new AWS Account

1. Go to http://aws.amazon.com
2. Click Sign up
3. Follow sign up instructions

FYI You will need a credit card but it will only get charged if you use resources outside the free tier and you will need a phone number to verify your identification.

### Setup IAM User

Reference: http://docs.aws.amazon.com/IAM/latest/UserGuide/Using_SettingUpUser.html

1. Log in to aws console https://console.aws.amazon.com
2. Go to IAM dashboard > Users
3. Create New Users
4. Enter user name and generate access key
5. Click on user > Permissions
6. Attach UserPolicy
7. Add Administrator access
8. Click on security credentials and set a password
9. Go to IAM dashboard and note the IAM User Sign-In URL
10. Sign in as your IAM user

### Install AWS CLI tools

Reference: http://docs.aws.amazon.com/cli/latest/userguide/installing.html
           http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html

1. Install cli
2. `aws configure` using your IAM credentials and us-east-1 as default region
3. Test `aws ec2 describe-instances`

## Launch Instance

1. Go to EC2 in the [AWS Console](https://console.aws.amazon.com)
2. Click _Launch Instance_
3. Select Ubuntu
4. Choose t2.micro (free tier)
5. Skip through next two screens to Step 5: Tag Instance
6. Give your instance a name, Click next
7. Create a new Security Group, name it blog, and keep the default SSH from anywhere rule for now
    * This will show a warning about SSH being accessible to the world.  This is fine for now but can be fixed if you choose "My IP" instead of "Anywhere".
8. Click Next and Launch
9. It will ask you about a KeyPair, this time create a new one.  It will have you download the private key to your computer.  You will need this to access the instance later.

At this point your instance will be created.  You will need to wait for it to be in the _running_ state before you can access it.


## Install App on Instance

1. Go to the EC2 Instances page in the console and get the public DNS of the instance you launched.
2. Use the public DNS and the key pair you created the instance with to ssh into the instance.
    * For example: `ssh -i si.pem ubuntu@ec2-54-210-57-41.compute-1.amazonaws.com`
3. Update the package manager: `sudo apt-get update`
4. Install git: `sudo apt-get install git`
5. Clone this repo: `git clone https://github.com/mtrahan/fuzzy-octo-computing-machine.git`
6. Change directories to the repo: `cd fuzzy-octo-computing-machine`
7. Run the setup-instances script to install all necessary ruby dependencies: `sudo ./setup-instances.sh`
8. Change directories to the ruby app directory: `cd blog`
9. Run `bundle install`
10. Setup the local database: `bin/rake db:migrate`
11. Start the App: `bin/rails server`
12. Go to your browser and hit the public DNS of the instance at port 3000.  Example: http://ec2-54-210-57-41.compute-1.amazonaws.com:3000
    * This will not work because the security group needs to have a rule added to open port 3000.
        1. Go to EC2 -> Security Groups
        2. Click on the _blog_ security group and add an **Incoming** rule to open a **TCP** port **3000** to all IPs **0.0.0.0/0**

## Use RDS Postgres Instead of Local Database

1. Go to RDS in AWS Console.
2. Click **Launch a DB Instance**
3. Choose **PostgreSQL**
4. Pick **No, this instance is intended for use outside of production or under the RDS Free Usage Tier**
5. Select the following:
    * DB Instance Class: __db.t1.micro__
    * Multi-AZ Deployment: __No__
    * Allocated Storage: __5__
    * DB Instance Identifier: __blog__
    * Set username and password.  Remember these.
6. On the next screen select the following:
    * Publicly Accessible: __No__
    * VPC Security Group(s): __blog__ (this is the same security group you created with your first instance)
    * Database Name: __blog__
    * Leave the rest with their default values
7. Launch!
8. Once the database is up and running, we need to open up the security group so our instances can call it.
    1. Go to EC2 -> Security Groups
    2. Click on __blog__ security group
    3. Add rule for __TCP__ for port __5432__ but this time add the __blog__ security group as the source.  This only allows instances in that security group to make calls to this port.
9. Get the endpoint for you DB from the RDS page.  It will look something like this: __blog.dw1zpjs4fexx.us-east-1.rds.amazonaws.com:5432__
10. Back on your EC2 instance with your app running on it, add the database configuration to connect to your RDS instance.
    1. In _config/database.yaml_, under production add `url: postgresql://blog:blogpassword@blog.cw1zpjs4feww.us-east-1.rds.amazonaws.com:5432/blog` but with your user/password and your connection string.
11. Make sure `gem 'pg'` is in your GemFile and run `bundle install again`
12. `export RAILS_ENV=production`
13. ```export SECRET_KEY_BASE=`bin/rake secret` ```
14. run `bin/rake db:migrate`
15. `bin/rails server`

## Create Image

1. Go to EC2 Instances page
2. Select instance
3. Click _Actions_ -> _Create Image_
4. Go to EC2 AMI page to see status of image

## Launch New Image using Image and CloudFormation

1. Clone git repo to local computer: `git clone https://github.com/mtrahan/fuzzy-octo-computing-machine.git`
2. Go to CloudFormation tab and click *Create New Stack*
3. Add a Name
4. Upload template to Amazon S3, choose the file __instance-only.template__ from the repo you just cloned
5. Click Next
6. Fill in the AmiId and the KeyPair name.  The AmiId will be the ID for the image created in the last section and the KeyPair name will be the one you created when you launched your first instance.
7. Add a **Name** tag to your instances.
8. Launch stack

When the instance comes up, you will have to ssh on the instance and manually start the app by setting the RAILS_ENV and the SECRET_KEY_BASE then running `bin/rails server`.

## Launch New Image and Automatically Start App on Instance Start Up

Same as *Launch New Image using Image and CloudFormation* but instead use the __instance-userdata.template__

## Launch Stack with Elastic Loadbalancer and AutoScaling Group

Same as *Launch New Image using Image and CloudFormation* but instead use the __elb-asg.template__

