1. Create an account on AWS (Already done, please use the following credentials to login):
https://589468337297.signin.aws.amazon.com/console

userid : student
password: same as azure vm


2. Install AWS CLI on your Azure ubuntu VM:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#cliv2-linux-install

####Snippet of commands which I used to install aws:
ubuntu@sambhi-linux:~/terraform_aws$ history | grep -i aws
  302  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  304  unzip awscliv2.zip
  306  cd aws/
  309  sudo ./aws/install 
  310  which aws
  311  aws --version


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

5. Next, Create a key with following command on your azure vm: (like we create a ssh key pair, Already added a key in code directory)
aws ec2 create-key-pair --key-name tf_key --query 'KeyMaterial' --output text > tf_key.pem

6. Next will be regular steps (i.e terraform init/plan/apply with terraform files containing aws syntax)


References:
https://learn.hashicorp.com/tutorials/terraform/aws-variables?in=terraform/aws-get-started


Troubleshooting:
----------------
IF you see an issue while login with ssh key "tf_key.pem" as follows:

student@ubuntu-host2:~/ELG5164/terraform_aws$ ssh -i tf_key.pem ec2-user@ec2-3-20-226-15.us-east-2.compute.amazonaws.com
The authenticity of host 'ec2-3-20-226-15.us-east-2.compute.amazonaws.com (3.20.226.15)' can't be established.
ECDSA key fingerprint is SHA256:5DvJ1GZL7ldPd5C+XXMa665sRYewFvP20NwFcuXNdVs.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'ec2-3-20-226-15.us-east-2.compute.amazonaws.com,3.20.226.15' (ECDSA) to the list of known hosts.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions 0664 for 'tf_key.pem' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
Load key "tf_key.pem": bad permissions
ec2-user@ec2-3-20-226-15.us-east-2.compute.amazonaws.com: Permission denied (publickey).
student@ubuntu-host2:~/ELG5164/terraform_aws$



THEN change the permissions of tf_key.pem file to 400 as follows:


student@ubuntu-host2:~/ELG5164/terraform_aws$ chmod 400 tf_key.pem 
student@ubuntu-host2:~/ELG5164/terraform_aws$ ssh -i tf_key.pem ec2-user@ec2-3-20-226-15.us-east-2.compute.amazonaws.com

       __|  __|_  )
       _|  (     /   Amazon Linux AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-ami/2018.03-release-notes/
4 package(s) needed for security, out of 6 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-172-16-0-204 ~]$ 
[ec2-user@ip-172-16-0-204 ~]$ 

