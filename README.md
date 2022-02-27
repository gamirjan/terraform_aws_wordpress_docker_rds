## Dockerized Wordpress on AWS
We are using terraform to provision infrastructure. Code uses and creates following aws services.

>VPC.

>Subnets, Route Tables, Internet Gateway.

>EC2 instances with dockerized wordpress.

>RDS mysql instance.

>Security Groups ․

>Application Load Balancer for EC2 Instacnes

### Before using the terraform, we need to export AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY as environment variables:

>export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxx"

>export AWS_SECRET_ACCESS_KEY="yyyyyyyyyyyyyyyyyyyy"

### To Generate and show an execution plan (dry run):

>terraform plan

### Deploy all the infrastructure needed on AWS using Terraform.

>terraform apply --auto-approve

### To destroy Terraform-managed infrastructure:

>terraform destroy --auto-approve
