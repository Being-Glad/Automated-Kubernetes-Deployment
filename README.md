# Automated Kubernetes Deployment (EKS)

[![Deploy workflow](https://github.com/Being-Glad/Automated-Kubernetes-Deployment/actions/workflows/deploy.yml/badge.svg?branch=main)](https://github.com/Being-Glad/Automated-Kubernetes-Deployment/actions/workflows/deploy.yml)

A production-style, automated pipeline that builds and pushes a Docker image to **Amazon ECR** and deploys a simple “Hello, World” web app to **Amazon EKS** using **Kustomize** + **kubectl**, all triggered on pushes to `main`.

---

## 🚀 Live App (Public)

**URL:**  
`http://a3697e724832c4be7aa0a7bd413c8687-162846347.ap-south-1.elb.amazonaws.com/`

You should see:

```html
<h1>Hello, World — Prod on EKS!</h1>
<p>Version: v0.1.0</p>
🧩 What’s Included
Terraform (IaC): Provisions VPC, EKS (v1.30), node group, ECR, GitHub OIDC, EKS RBAC.

Containerization: Minimal Docker image for a small Flask app.

Kubernetes Manifests: Deployment + Service (type LoadBalancer) with Kustomize overlays.

CI/CD (GitHub Actions):

Trigger on push to main

Build & tag image (<sha>, latest)

Trivy vulnerability scan (fails on HIGH/CRITICAL)

Push to ECR

kubectl apply -k overlays/...

Wait for rollout

RBAC via EKS Access Entries for GitHub Actions & local CLI.

🗺️ Architecture (high level)
vbnet
Copy code
GitHub → Actions (OIDC → IAM role)
  ├─ Build & scan image
  ├─ Push to ECR
  └─ Deploy with kubectl/kustomize
AWS:
  VPC + Subnets + IGW
  EKS (Managed Node Group)
  ECR (image storage)
  ELB (Service type=LoadBalancer) → Public URL
🛠️ Usage (quick start)
1) Provision infra (Terraform)
bash
Copy code
cd terraform
terraform init
terraform apply -auto-approve -var region=ap-south-1 -var project_name=hello-eks
Useful outputs:

cluster_name: hello-eks

cluster_endpoint: https://…eks.amazonaws.com

ecr_repo_url: 630398150656.dkr.ecr.ap-south-1.amazonaws.com/hello-eks

gha_role_arn: arn:aws:iam::630398150656:role/hello-eks-gha-role

2) Deploy via CI/CD
Push to main:

bash
Copy code
git add .
git commit -m "Trigger CI"
git push origin main
The workflow will:

Build & scan → Push to ECR → kubectl apply -k → Rollout.

3) Get the app URL
bash
Copy code
kubectl -n hello get svc hello-web -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'; echo
# Example output:
# a3697e724832c4be7aa0a7bd413c8687-162846347.ap-south-1.elb.amazonaws.com
Test:

bash
Copy code
ELB=$(kubectl -n hello get svc hello-web -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
curl -i "http://$ELB/"
📂 Repo Structure
bash
Copy code
.
├─ .github/workflows/deploy.yml      # CI/CD pipeline
├─ app/                              # Simple Flask app
│  ├─ server.py
│  └─ requirements.txt
├─ k8s/
│  ├─ base/                          # Base manifests (Deployment, Service)
│  │  ├─ kustomization.yaml
│  │  ├─ deployment.yaml
│  │  └─ service.yaml
│  └─ overlays/
│     └─ hello/                      # “prod” overlay (namespace=hello)
│        ├─ kustomization.yaml
│        └─ patch-deployment.yaml
└─ terraform/                        # IaC for VPC, EKS, ECR, IAM
   ├─ main.tf
   ├─ variables.tf
   ├─ outputs.tf
   └─ iam_github_oidc.tf
🔐 Security & Extras
GitHub OIDC → AWS IAM role with least-privileged ECR + EKS access

Trivy: fails build on HIGH/CRITICAL vulns

Kustomize: templates image tag replacement per overlay

🧹 Teardown / Cost Notes
EKS + the public Load Balancer incur charges while running.

Full destroy:

bash
Copy code
cd terraform
terraform destroy
Keep cluster, remove public LB:

bash
Copy code
kubectl -n hello delete svc hello-web
🧠 Design Choices (brief)
EKS Managed Node Group for simplicity; Fargate is an easy swap later.

Service type=LoadBalancer for a quick public endpoint (no Ingress needed).

Kustomize layers to keep base manifests clean.

OIDC avoids long-lived AWS secrets in CI.

Trivy shifts security left with an automated gate.

🌱 Future Enhancements
ALB Ingress + HTTPS (ACM) + custom domain (Route 53)

Prometheus + Grafana (observability)

External Secrets for config/secret management

Horizontal Pod Autoscaler

