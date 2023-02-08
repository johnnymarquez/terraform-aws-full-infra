## Project Structure

Full AWS sample infrastructure with VPC, private/public instances, application load balancer, terraform backend s3
bucket, public/private/alb security groups, Elastic IPs allocation, latest Ubuntu AMI, automatic ssh key generation, and
complex data types.
All the resources in this project are separated in different ```.tf``` files for ease of identification, using
[terraform aws modules](https://github.com/terraform-aws-modules) as much as possible with version constrains.

## Authentication

Export AWS Credentials on the command line:

```
export AWS_ACCESS_KEY_ID={}
export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=us-west-2
```

## Initialization

Run the project by running the following commands

```
terraform init
terraform plan
terraform apply
```

## SSH Key

SSH key for Ubuntu instances are automatically generated and associated with the EC2 instances as a sensitive variable.
In order to obtain the ssh key, run ```terraform output -raw private_key```. This procedure is only applicable to the
exercise and should be avoided in production.

## S3 Backend

Initially the project is configured using local terraform backend. However, the code includes the creation of an S3
bucket that can be used as backend. In order to transfer the backend after the bucket creation, uncomment the backend
configuration on ```main.tf``` file and run ```terraform init```. A prompt should appear asking to migrate current
backend.

## Side Notes

There are no workspaces/environments configured in this project, reason why all the values are configured
under ```terraform.tfvars``` file. However, a good approach is to set up different environments leveraging on terraform
workspaces in a ```/env``` subdirectory with multiple ```.tfvars``` files.

Security Group specification it's the only resource not set up using variables. This is due to its nature to being a
very specific resource configuration, and as such can be replicated to different environments as it is.

## Resources Destruction

If a complete destruction of resources is required, remove the S3 backend configuration first to locally
using ```terraform init -migrate-state```, and manually remove ther s3 bucket contents. It must be empty in order to
proceed with full deletion.
Then proceed with ```terraform destroy```.

