# Automated Kubernetes Deployment — Hello EKS

**Repository:** [https://github.com/Being-Glad/Automated-Kubernetes-Deployment](https://github.com/Being-Glad/Automated-Kubernetes-Deployment)  
**Live App URL:** [http://a4dc391d7f5b24fd1b08e26e8db178fb-2046607023.ap-south-1.elb.amazonaws.com/](http://a4dc391d7f5b24fd1b08e26e8db178fb-2046607023.ap-south-1.elb.amazonaws.com/)  
**Screenshot:** `asset/live_Website.png`

---

## 📘 Overview

This repository demonstrates an automated **DevOps pipeline** that builds, containerizes, and deploys a simple **“Hello, World” Flask web application** to **AWS EKS** (Elastic Kubernetes Service).  
The deployment is fully automated using **Terraform** for Infrastructure as Code (IaC), **Kustomize** for Kubernetes manifest management, and **GitHub Actions** for CI/CD.

It satisfies all the requirements of the given take-home task:
- ✅ Infrastructure-as-Code  
- ✅ Containerization  
- ✅ Kubernetes manifests  
- ✅ Automated CI/CD  
- ✅ Publicly accessible application  

---

## 🗂 Repository Structure

.
├── app/ # Flask web application
│ ├── Dockerfile # Docker build definition
│ ├── requirements.txt # Python dependencies
│ └── server.py # Flask app code
│
├── asset/
│ └── live_Website.png # Screenshot of live website
│
├── k8s/
│ ├── base/ # Base manifests (deployment, service, namespace)
│ └── overlays/prod/ # Production overlay using Kustomize
│
├── terraform/ # Terraform IaC for AWS EKS, VPC, ECR, IAM
│
├── .github/workflows/
│ └── deploy.yml # CI/CD workflow (GitHub Actions)
│
└── README.md

yaml
Copy code

---

## 🌐 Live Demo

**Public URL:**  
👉 [http://a4dc391d7f5b24fd1b08e26e8db178fb-2046607023.ap-south-1.elb.amazonaws.com/](http://a4dc391d7f5b24fd1b08e26e8db178fb-2046607023.ap-south-1.elb.amazonaws.com/)

**Expected Output:**  
Hello, World — Prod on EKS!
Version: v0.1.0

## ⚙️ Deployment Summary

- **Infrastructure:** AWS EKS provisioned via Terraform (IaC)
- **Application:** Python Flask web app
- **Container Registry:** AWS ECR
- **Orchestration:** Kubernetes (Kustomize base + overlay)
- **CI/CD:** GitHub Actions
- **Authentication:** OIDC between GitHub and AWS (no static credentials)

## 🤖 CI/CD Workflow (GitHub Actions)

**Trigger:** On push to `main` branch.  
**Workflow steps:**
1. Build Docker image from `app/Dockerfile`.
2. Authenticate to AWS ECR using OIDC (no stored AWS secrets).
3. Push image to ECR.
4. Deploy to EKS using `kubectl` + `kustomize`.

All workflow logic is in `.github/workflows/deploy.yml`.

## 🧠 Design Decisions

- **Terraform:** Ensures reproducible cloud resources (EKS, VPC, ECR, IAM).  
- **ECR + OIDC:** Secure image management and keyless AWS access from GitHub Actions.  
- **Kustomize:** Simplifies environment configuration (base + overlays).  
- **GitHub Actions:** Provides continuous delivery integrated with version control.  
- **Flask app:** Lightweight, fast, and portable — ideal for container demo.

## 📸 Proof of Deployment

![Live Website Screenshot](asset/live_Website.png)

## 📄 Submission Summary

**Deliverables included:**
- Public GitHub Repository (with IaC, manifests, CI/CD)
- Live URL (AWS EKS LoadBalancer)
- Screenshot of working deployment
- README with setup & teardown steps

**Repository URL:**  
🔗 [https://github.com/Being-Glad/Automated-Kubernetes-Deployment](https://github.com/Being-Glad/Automated-Kubernetes-Deployment)  

**Author:** Om Pandey  
**Date:** October 2025  
**Location:** India 🇮🇳
