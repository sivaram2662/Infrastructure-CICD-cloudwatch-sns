Infrastructue setup and deployment deployment guide
----------------------------------------------------

PART-1 : Infrastructure as Code (IaC) with Terraform
-------
1. prerequisiies
---------------
1.Terraform installed (>=1.3.0)
2.AWS CLI configured (aws configure)
3.GitHub repository for code
4.IAM user with appropriate permissions

2. VPC Configuration(Virtual Private Cloud)
------------------------------------------
1.Create a VPC block (10.0.0.0/16)
2.Create public and private subnets across multiple availability zones
3.Add Internet Gateway and route tables
4.Enable NAT Gateway for private subnet internet access (if needed)

3. SG(security Group)
---------------------
1.Bastion Host SG: Allow SSM access only.
2.ALB SG: Allow inbound HTTP (80/443)
3.App EC2 SG: Allow only traffic from ALB
4.RDS SG: Allow access only from App EC2 SG

4. Bastion Host(Amazon Linux)
-----------------------------
1.Deploy EC2 in the public subnet
2.Enable SSM access (IAM role + instance profile)
3.Disable SSH access; use SSM Session Manager

5. Application Load Balancer(ALB) & Auto Scaling Group(ASG)
-----------------------------------------------------------
1.Launch Template for app instances
2.ALB with listener (HTTP)
3.Target Group associated with the ASG
4.ASG with minimum/maximum capacity and health checks

6. RDS instance
---------------
1.RDS MySQL/PostgreSQL in private subnets
2.Use parameter group, subnet group, and security groups
3.Backup and monitoring configurations

7. IAM role
-----------
1.Role for EC2 to allow
2.CloudWatch log publishing
3.SSM access

8. Access via SSM Session Manager
---------------------------------
1.SSM agent is installed on EC2
2.AmazonSSMManagedInstanceCore policy is attached


PART-2 :  CI/CD Pipeline with GitHub Actions
----------------------------------------------
1. prerequisites
----------------
1.Source code (Flask)
2.GitHub repo
3.Bastion EC2 with access to private subnet (if deploying to ASG)

2. GitHub Actions Workflow
----------------------------
1.Create .github/workflows/deploy.yml

3. deploy the application



PART-3 : Monitoring & Logging with CloudWatch
------------------------------------------------
1. Cloudwatch logs
------------------
1.Install and configure awslogs on EC2
2.push app logs to /aws/ec2

2. Cloudwatch alarms
-------------------
1.High CPU (e.g., > 70% for 5 mins)
2.Low disk space
3.Custom metrics (if using CloudWatch Agent)

3. SNS notification
-------------------
1.Create SNS topic
2.Subscribe via email
3.Connect CloudWatch alarms to SNS topic