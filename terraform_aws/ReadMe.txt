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
    "UserId": "AIDAYSPYNASIRRBR5DMSM",
    "Account": "589468337297",
    "Arn": "arn:aws:iam::589468337297:user/student"
}


Above 4 steps will ensure that your aws account has been setup properly. (Somethign similar till the "az login" step of Microsoft Azure)

5. Next, Create a key with following command on your azure vm: (like we create a ssh key pair)
aws ec2 create-key-pair --key-name tf_key --query 'KeyMaterial' --output text > tf_key.pem

6. Next will be regular steps (i.e terraform init/plan/apply with terraform files containing aws syntax)


References:
https://learn.hashicorp.com/tutorials/terraform/aws-variables?in=terraform/aws-get-started
