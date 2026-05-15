# locals.tf
locals {
  # TODO-1: name_prefix를 "tf-prac-<environment>" 형식으로 만들기
  # 힌트: name_prefix = "tf-prac-${var.environment}"
  # 사용 예: tf-prac-dev, tf-prac-prod
  name_prefix = "tf-prac-${var.environment}"
}
