# GitHub OIDC provider (required by the assume role policy)
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  # GitHub's OIDC root cert thumbprint
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# Trust policy: allow GitHub Actions from your repo to assume this role via OIDC
data "aws_iam_policy_document" "gha_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Limit to your repo & main branch
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:Being-Glad/Automated-Kubernetes-Deployment:ref:refs/heads/main"]
    }
  }
}

# Role assumed by GitHub Actions
resource "aws_iam_role" "gha_role" {
  name               = "${var.project_name}-gha-role"
  assume_role_policy = data.aws_iam_policy_document.gha_assume.json
}

# Inline policy: ECR push+pull (incl. GetDownloadUrlForLayer) and EKS DescribeCluster
data "aws_iam_policy_document" "gha_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "eks:DescribeCluster"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "gha_policy" {
  name   = "${var.project_name}-gha-policy"
  policy = data.aws_iam_policy_document.gha_policy.json
}

resource "aws_iam_role_policy_attachment" "gha_attach" {
  role       = aws_iam_role.gha_role.name
  policy_arn = aws_iam_policy.gha_policy.arn
}
