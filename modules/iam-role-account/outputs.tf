output "arn" {
  value = aws_iam_role.scalr_aws_integration.arn
  description = "The ARN of created role"
}

output "principal_access_key" {
  value = can(aws_iam_access_key.principal[0].id) ? aws_iam_access_key.principal[0].id : null
}

output "principal_secret_key" {
  value = can(aws_iam_access_key.principal[0].secret) ? aws_iam_access_key.principal[0].secret : null
  sensitive = true
}