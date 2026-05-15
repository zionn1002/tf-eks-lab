# CI/CD 파이프라인 동작 확인용
terraform {
  required_version = ">= 1.15.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.80" }
  }
}
provider "aws" { region = "ap-northeast-2" }
