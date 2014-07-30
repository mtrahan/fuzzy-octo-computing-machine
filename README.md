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
