terraform {
  required_providers {
    scalr = {
      source  = "registry.scalr.dev/scalr/scalr"
      version = "1.0.0-rc-develop"
    }
  }
}

resource "scalr_provider_configuration" "scalr_managed" {
  name                   = var.name
  account_id             = var.scalr_account_id
  export_shell_variables = var.export_shell_variables
  environments           = var.scalr_environments

  aws {
    credentials_type    = "role_delegation"
    account_type        = var.account_type
    trusted_entity_type = var.trusted_entity_type

    role_arn = local.iam_role_arn
    external_id = local.external_id
  }
}
