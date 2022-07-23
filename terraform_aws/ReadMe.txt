1. Create an account on AWS (Already done, please use the following credentials to login):

https://589468337297.signin.aws.amazon.com/console

userid : student
password: same as azure vm


2. Install AWS CLI on your Azure ubuntu VM:

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#cliv2-linux-install

####Snippet of commands which I used to install aws:
ubuntu@sambhi-linux:~/terraform_aws$ history | grep -i aws
  301  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  302  unzip awscliv2.zip
  303  sudo ./aws/install 
  304  which aws
  305  aws --version


3. Run "aws configure" on azure ubuntu vm:

ubuntu@sambhi-linux:~/terraform_aws$ aws configure
AWS Access Key ID [****************XL3C]:                            <<<<<<<You will get this from user student info in aws account
AWS Secret Access Key [****************0TYx]:                        <<<<<<<You will get this from user student info in aws account 
Default region name [us-east-2]:                                     <<<<<<< specify zone as "us-east-2" 
Default output format [json]:                                        <<<<<<<output format "json"
ubuntu@sambhi-linux:~/terraform_aws$ 


4. Verify aws configuration by executing "aws sts get-caller-identity" as follows:

ubuntu@sambhi-linux:~/terraform_aws$ aws sts get-caller-identity
{
    "UserId": "ABDCYDPENASIZRBR5DMMM",
    "Account": "123456787890",
    "Arn": "arn:aws:iam::123456787890:user/student"
}


Above 4 steps will ensure that your aws account has been setup properly. (Something similar to the "az login" step of Microsoft Azure)


5. Next will be regular steps (i.e terraform init/plan/apply with terraform files containing aws syntax)


6. After terraform apply, 2 files (hosts and tf_key.pem) are created:

- hosts (ansible inventory file)
- tf_key.pem (ssh private key)


7. ssh to aws instance: 
ssh -i tf_key.pem ec2-user@<aws-instance-public-ip>


8. Install nginx using ansible playbook:

ansible-playbook nginx.yml -i ./hosts


9. Check http server is running on AWS instance:

curl <aws-instance-public-ip>


References:
https://learn.hashicorp.com/tutorials/terraform/aws-variables?in=terraform/aws-get-started

