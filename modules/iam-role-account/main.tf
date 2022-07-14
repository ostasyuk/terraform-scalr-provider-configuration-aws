data "aws_iam_user" "principal" {
  count = var.create_principal_user == false && var.scalr_managed_principals == false ? 1 : 0
  user_name = var.principal_username
}

resource "aws_iam_user" "principal" {
  count = var.scalr_managed_principals == false && var.create_principal_user == true  ? 1 : 0
  name = var.principal_username
}

locals {
  username = can(data.aws_iam_user.principal[0].user_name) ? data.aws_iam_user.principal[0].user_name : (can(aws_iam_user.principal[0].name) ? aws_iam_user.principal[0].name : null)
  created_arn = can(data.aws_iam_user.principal[0].arn) ? data.aws_iam_user.principal[0].arn : (can(aws_iam_user.principal[0].arn) ? aws_iam_user.principal[0].arn : null)
  identifier = local.created_arn == null ? "arn:aws:iam::${var.principal_account_id}:user/${var.principal_username}" : local.created_arn
}

resource "aws_iam_access_key" "principal" {
  count = local.username != null ? 1 : 0
  user = local.username
}

data "aws_iam_policy_document" "scalr_aws_integration_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [local.identifier]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.external_id]
    }
  }
}

data "aws_iam_policy_document" "scalr_aws_integration" {
  statement {
    effect = "Allow"

    actions   = var.policy_permissions
    resources = var.policy_resources
  }
}

resource "aws_iam_policy" "scalr_aws_integration" {
  name   = var.policy_name
  policy = data.aws_iam_policy_document.scalr_aws_integration.json
}

resource "aws_iam_role" "scalr_aws_integration" {
  name                 = var.role_name
  description          = "Role for Scalr-AWS Integration"
  assume_role_policy   = data.aws_iam_policy_document.scalr_aws_integration_assume_role.json
  max_session_duration = var.max_session_duration * 60

  # AWS has a 10 second latency to configure the trusted entities for IAM role.
  # otherwise will lead to error "<user-arn> is not authorized to perform  sts:AssumeRole on resource <role-arn>"
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "aws_iam_role_policy_attachment" "scalr_aws_integration" {
  role       = aws_iam_role.scalr_aws_integration.name
  policy_arn = aws_iam_policy.scalr_aws_integration.arn
}