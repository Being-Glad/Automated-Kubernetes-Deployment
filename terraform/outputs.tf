output "cluster_name"     { value = module.eks.cluster_name }
output "cluster_endpoint" { value = module.eks.cluster_endpoint }
output "cluster_ca"       { value = module.eks.cluster_certificate_authority_data }
output "ecr_repo_url"     { value = aws_ecr_repository.app.repository_url }
output "gha_role_arn"     { value = aws_iam_role.gha_role.arn }
