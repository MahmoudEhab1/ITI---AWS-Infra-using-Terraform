# ITI---AWS-Infra-using-Terraform
Secure Web Application With Public  Proxy + Private Backend On AWS  Using Terraform

**Secure Web App with Public Proxy + Private Backend on AWS using Terraform**
This project deploys a scalable and secure AWS infrastructure using Terraform.  
It provisions networking, compute resources, and load balancers to host a full-stack web application. 
---
 
##  **Architecture Overview**
A **VPC** (`10.0.0.0/16`) consisting of:
- **2 Public Subnets** > EC2 instances acting as **Nginx Reverse Proxies**  
- **2 Private Subnets** > EC2 instances running **Web Application Backend (Node.js)**  
- **NAT Gateway + Internet Gateway**  
- **2 Load Balancers**:
  - **Public ALB** > Directs traffic to proxy EC2 instances  
  - **Internal ALB** > Directs traffic from proxies to backend servers  
---
 
## **Infrastructure Diagram**
<img width="830" height="428" alt="image" src="https://github.com/user-attachments/assets/f69d9fa4-4664-4ea7-b473-c861fead4c31" />
---
 
##  **Deployment Steps**
 
### 1. **Initialize Terraform & Workspace**
 
```bash
terraform init
terraform workspace new dev
````
 
### 2. **Plan & Apply**
 
```bash
terraform plan
terraform apply
```
##  **Verification**

After deployment: 
1. **Frontend:**

   Access the public ALB DNS in your browser.
 
2. **Backend:**

   The proxy forwards traffic to the **Internal ALB**, serving the Node.js app.

 
