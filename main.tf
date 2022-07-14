terraform {
  required_version = "> 0.14.0"
}

data "scalr_environment" "available" {
  count = local.all_environments ? 0 : length(var.scalr_environments)
  account_id = var.scalr_account_id
  name = var.scalr_environments[count.index]
}

locals {
  all_environments = var.scalr_environments == ["*"]
  environments = local.all_environments ? var.scalr_environments : data.scalr_environment.available.*.id
}

resource "scalr_provider_configuration" "scalr_managed" {
  name                   = var.name
  account_id             = var.scalr_account_id
  export_shell_variables = var.export_shell_variables
  environments           = local.environments

  aws {
    credentials_type    = "role_delegation"
    account_type        = var.account_type
    trusted_entity_type = var.trusted_entity_type
    access_key = local.principal_access_key
    secret_key = local.principal_secret_key

    role_arn = local.iam_role_arn
    external_id = local.external_id
  }
}