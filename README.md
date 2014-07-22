# Getting Started
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

# Launch Instance

1. Instance
2. Security Groups
3. KeyPair

# Login

```
ssh -i si.pem ubuntu@ec2-54-210-57-41.compute-1.amazonaws.com
```
