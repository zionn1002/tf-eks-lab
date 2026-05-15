# vpc.tf

# TODO-1: aws_vpc.main 리소스 정의
# - cidr_block: var.vpc_cidr 사용
# - enable_dns_hostnames: true
# - enable_dns_support: true
# - tags: { Name = "${local.name_prefix}-vpc" }
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

# TODO-2: aws_internet_gateway.main 리소스 정의
# - vpc_id: 위에서 만든 aws_vpc.main의 id 참조
# - tags: { Name = "${local.name_prefix}-igw" }
# 힌트: vpc_id = aws_vpc.main.id
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-igw"
  }
}
