terraform {
  required_version = ">= 1.15.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.80" }
  }
}

provider "aws" { region = "ap-northeast-2" }

data "aws_caller_identity" "current" {}

# GitHub OIDC Provider
# AWS가 GitHub에서 발급한 JWT 토큰을 신뢰하도록 등록
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

# GitHub Actions용 IAM Role
# Condition: 지정한 저장소의 GitHub Actions만 이 Role Assume 가능
resource "aws_iam_role" "github_actions" {
  name = "github-actions-terraform-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:*"
        }
      }
    }]
  })
}

# AdministratorAccess 연결 (실습용, 실무에서는 최소 권한 적용)
resource "aws_iam_role_policy_attachment" "admin" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

variable "github_org" { description = "GitHub 사용자명 또는 조직명" }
variable "github_repo" { description = "GitHub 저장소명" }

output "role_arn" { value = aws_iam_role.github_actions.arn }
output "aws_account_id" { value = data.aws_caller_identity.current.account_id }
