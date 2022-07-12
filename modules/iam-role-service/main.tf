data "aws_iam_policy_document" "scalr_aws_integration_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
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
}

resource "aws_iam_role_policy_attachment" "scalr_aws_integration" {
  role       = aws_iam_role.scalr_aws_integration.name
  policy_arn = aws_iam_policy.scalr_aws_integration.arn
}
