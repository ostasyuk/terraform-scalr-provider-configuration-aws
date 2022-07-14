output "arn" {
  value = aws_iam_role.scalr_aws_integration.arn
  description = "The ARN of created role"
}