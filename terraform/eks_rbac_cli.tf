data "aws_caller_identity" "me" {}

# Access entry for "who am I" right now (works for user or assumed-role)
resource "aws_eks_access_entry" "cli" {
  cluster_name  = module.eks.cluster_name
  principal_arn = data.aws_caller_identity.me.arn
  type          = "STANDARD"

  tags = { Project = var.project_name }
}

resource "aws_eks_access_policy_association" "cli_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_eks_access_entry.cli.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
