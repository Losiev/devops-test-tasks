# 🚀 Deployment Instructions (Step-by-Step)
Step 1: Prerequisites (What you need first)
1. AWS Account: Make sure you have an AWS account with admin permissions.
2. Terraform: Install Terraform on your local machine.
3. AWS CLI: Install and configure the AWS CLI with your credentials (run aws configure).
4. Create AWS Key Pair:
* Go to the EC2 service in your AWS Console.
* Go to "Key Pairs" and create a new key pair (e.g., key-for-mate-task).
* Download the .pem file (e.g., key-for-mate-task.pem) and save it in your project folder.

# Step 2: Prepare Your Code Files
1. Create a new folder for your project (e.g., aws-ecs-project).
2. Inside that folder, create all the files we discussed. Make sure the key_name in your aws_instance resource in ecs.tf matches the name you created in Step 1.

Your folder should look like this:

* network.tf (VPC, Subnets, IGW, Routes)
* security_groups.tf (ALB SG, ECS Instance SG, EFS Mount SG)
* iam.tf (ECS Instance Role, Task Execution Role)
* efs.tf (EFS File System, Mount Targets)
* ecs.tf (ECS Cluster, EC2 Instance, Task Definition, Service)
* alb.tf (ALB, Target Group, Listener)
* mount_efs_userdata.sh (The user data script)
* provider.tf / main.tf / variables.tf (Your core Terraform files)
* tm-devops-key.pem (Your downloaded SSH key)

# Step 3: Deploy the Infrastructure

1. Open your terminal and go into your project folder.

2. Initialize Terraform: This downloads the AWS provider.

```
terraform init
```

3. Plan the deployment: (Optional) This shows you what Terraform will create.

```
terraform plan
```
4. Apply the configuration: This will build all the resources. Type yes when it asks.

```
terraform apply
```
5. Wait for 3-5 minutes. Terraform will build everything. When it is finished, it will show you the alb_dns_name and ec2_instance_public_ip in the output.

# Step 4: Upload the Web Application (The Manual Step)

1. Connect to the instance using SSH (replace <your-key-file.pem> and <your-ip-address>):

```
ssh -i "key-for-mate-task.pem.pem" ec2-user@<your-ip-address>
```

2. Create the HTML file: Once you are connected, run this command to create the content on the EFS drive.

```
echo '<h1>Devops rules the world!</h1>' | sudo tee /mnt/efs-data/index.html
```
3. Log out of the instance by typing exit.

# Step 5: Verify Your Website

1. Get the ALB address from the Terraform output:

```
terraform output alb_dns_name
```

2. Open your web browser and paste the alb_dns_name (it looks like tm-devops-test-alb-....amazonaws.com).

3. Result: You should see your website with the message "Devops rules the world!"

# Step 6: Clean Up (When you are finished)
To avoid paying for the resources, run this command to destroy everything you built:
```
terraform destroy --auto-approve
```