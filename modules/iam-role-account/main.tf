data "aws_iam_policy_document" "scalr_aws_integration_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.principal_account_id}:user/${var.principal_username}"]
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
