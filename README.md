# Automated Kubernetes Deployment (AWS EKS)

Automated deployment of a sample web application to **AWS EKS** using **Terraform**, **Docker**, **Kustomize**, and **GitHub Actions** with **OIDC** (no long-lived AWS keys). Includes **Trivy** image scanning in CI.

## Quick Start
1. Install: Git, Docker, AWS CLI, Terraform, kubectl, kustomize.
2. Create IAM user for CLI + run `aws configure` (region: ap-south-1 or your choice).
3. `cd terraform && terraform init && terraform apply -auto-approve -var region=ap-south-1 -var project_name=hello-eks`
4. In GitHub repo → Settings → Secrets and variables → Actions:
   - `AWS_REGION` = your region (e.g., ap-south-1)
   - `AWS_ROLE_TO_ASSUME` = value of `gha_role_arn` from Terraform output
5. Push to `main` → CI builds, scans, pushes to ECR, deploys to EKS.
6. Get URL: `kubectl -n hello get svc hello-web -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'`

## Public URL
Paste the external hostname here once deployed:http://<external-hostname>/

