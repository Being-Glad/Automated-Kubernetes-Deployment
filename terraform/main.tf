# VPC (public subnets with public IPs on launch)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  # ensure nodes launched in public subnets get public IPs
  map_public_ip_on_launch = true

  public_subnet_tags  = { "kubernetes.io/role/elb" = "1" }
  private_subnet_tags = { "kubernetes.io/role/internal-elb" = "1" }

  tags = { Project = var.project_name }
}

# ECR repo for the app
resource "aws_ecr_repository" "app" {
  name = var.project_name

  image_scanning_configuration { scan_on_push = true }

  tags = { Project = var.project_name }
}

# EKS cluster + node group
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.project_name
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  # Make API reachable by GitHub runner
  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = false
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"] # (simplest for CI; tighten later if you want)

  eks_managed_node_groups = {
    default = {
      desired_size   = 1
      min_size       = 1
      max_size       = 1
      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
      subnet_ids     = module.vpc.public_subnets
    }
  }

  # Grant the GitHub Actions role (from iam_github_oidc.tf) cluster-admin
  access_entries = {
    gha = {
      principal_arn = aws_iam_role.gha_role.arn

      policy_associations = {
        admin = {
          policy_arn   = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = { type = "cluster" }
        }
      }
    }
  }

  tags = { Project = var.project_name }
}
