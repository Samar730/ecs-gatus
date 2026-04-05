# Gatus Health Monitoring — Deployed on AWS ECS Fargate

## Introduction
This project deploys Gatus — an open source health monitoring dashboard — onto 
AWS ECS Fargate. Gatus continuously monitors configured endpoints and displays 
their status in a clean dashboard, making it easy to see the health of your 
services at a glance.

The infrastructure is fully provisioned using Terraform IaC across two 
availability zones for high availability, with three GitHub Actions CI/CD 
pipelines handling image builds, security scanning, and deployments. The 
application is containerised using Docker and served securely over HTTPS.

## What is Gatus?

Gatus is an open source health monitoring tool written in Go. It continuously 
monitors configured endpoints — HTTP, TCP, DNS, and more — and displays their 
status on a clean dashboard. It supports alerting, response time tracking, and 
status history, making it a lightweight alternative to more complex monitoring 
solutions.

In this project Gatus is configured to monitor external endpoints and display 
their health status at status.cloudbysamar.com.

## Architecture Diagram

![Architecture Diagram](docs/architecture-diagram.png)

## Prerequisites

- AWS account with appropriate permissions
- Terraform installed (v1.0+)
- Docker installed
- AWS CLI configured
- A registered domain managed via Route53
- GitHub repository with the following secrets configured:
  - `AWS_ROLE_TO_ASSUME` — IAM role ARN for GitHub Actions OIDC authentication

## Tech Stack

**Infrastructure & Cloud**
- AWS: VPC, ECS Fargate, ECR, ALB, ACM, Route53, CloudWatch, S3
- Terraform: Modular Infrastructure as Code (7 modules)

**CI/CD & Security**
- GitHub Actions
- OIDC for AWS authentication
- Grype for container image scanning
- Checkov for IaC security scanning

**Application**
- Gatus (Go/Golang)
- Docker (multi-stage build)

## Project Overview

This project demonstrates end-to-end infrastructure provisioning and deployment 
automation on AWS, built across four phases:

| Phase | Description | Status |
|-------|-------------|--------|
| 1 — Docker | Containerise Gatus and test locally | ✅ Complete |
| 2 — ClickOps | Manual deployment via AWS console | ✅ Complete |
| 3 — Terraform | Provision full infrastructure as code | ✅ Complete |
| 4 — CI/CD | Automate builds and deployments via GitHub Actions | ✅ Complete |

## Architecture Overview

User requests hit Route53 DNS which resolves status.cloudbysamar.com to the 
ALB via an alias record. The ALB handles TLS termination using an ACM certificate 
and forwards traffic to Gatus containers running on port 8080. All container 
workloads run in private subnets across two availability zones, with the ALB as 
the sole public entry point. A regional NAT Gateway handles outbound traffic from 
the private subnets, allowing Gatus to reach external endpoints for health checks.

### Docker Design
The Dockerfile uses a multi-stage build separating Go compilation from the Alpine runtime:
- Reduces final image size by over 50%
- Removes build dependencies from the production image
- Reduces attack surface with fewer packages
- Container runs as a non-root user (appuser) limiting blast radius of any potential vulnerability

### Private ECS Workloads
Placing ECS tasks in private subnets was a deliberate security decision:
- Prevents direct internet access to containers
- Forces all inbound traffic through the ALB
- Aligns with AWS well-architected framework best practices

### Application Load Balancer
The ALB serves as the sole public entry point:
- Routes traffic to ECS tasks across both availability zones
- Health checks container instances before routing traffic
- Terminates TLS using an ACM certificate

### Modular Terraform
Infrastructure is split across seven modules (vpc, sg, iam, alb, acm, route53, ecs):
- Each module owns a specific concern
- Changes to one module don't affect others
- Easier to maintain, extend and reason about

### IAM & Least Privilege
- ECS task execution role scoped to only the permissions required to pull images 
  from ECR and write logs to CloudWatch
- GitHub Actions authenticates via OIDC using a dedicated IAM role, eliminating 
  the need for long-lived access keys

## CI/CD Pipelines

Three GitHub Actions pipelines automate the build, deployment and teardown process:

### build.yml
- Triggered automatically on push to main (path filtered to app, config and Dockerfile changes)
- Builds Docker image tagged with commit SHA
- Scans image for vulnerabilities using Grype (fails on HIGH/CRITICAL)
- Pushes image to ECR on successful scan

![build.yml](docs/build-pipeline.png)

### apply.yml
- Manually triggered via workflow_dispatch (continuous delivery)
- Runs Checkov IaC security scan before applying
- Runs terraform fmt, validate, plan and apply
- Uses OIDC for secure AWS authentication
- Image tag passed automatically via TF_VAR_image_tag using commit SHA

![apply.yml](docs/apply-pipeline.png)

### destroy.yml
- Manually triggered via workflow_dispatch with confirmation input
- Requires typing "destroy" to confirm before pipeline runs
- Runs terraform plan -destroy followed by terraform destroy

![destroy.yml](docs/destroy-pipeline.png)

## How to Deploy

### 1. Bootstrap
Sets up the remote state backend and OIDC authentication:
```bash
cd bootstrap
terraform init
terraform apply
```

### 2. Configure GitHub Secrets
Add the following secret to your GitHub repository:
- `AWS_ROLE_TO_ASSUME` — IAM role ARN output from bootstrap

### 3. Build and Deploy
- Push a change to main to trigger the build pipeline automatically
- Once build succeeds, trigger the apply pipeline manually via GitHub Actions
- To tear down, trigger the destroy pipeline and type "destroy" to confirm


## Future Improvements

- Replace the NAT Gateway with VPC endpoints for ECR and CloudWatch — the NAT 
Gateway is the most expensive component in this setup for what it actually does
- Add AWS WAF to the ALB to protect against common web exploits
- Enable VPC Flow Logs for network visibility and threat detection
- Enable CloudWatch log encryption using KMS 