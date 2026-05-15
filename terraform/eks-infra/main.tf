# CI/CD 파이프라인 동작 확인용
terraform {
  required_version = ">= 1.15.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.80" }
  }
}
provider "aws" { region = "ap-northeast-2" }

# 파이프라인 테스트용 변수 (실제 리소스 미생성)
variable "test_tag" {
  description = "CI/CD 파이프라인 테스트용"
  default     = "cicd-lab-test"
}
