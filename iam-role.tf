provider "aws" {
  region = var.region
}

data "aws_iam_role" "existing" {
  count = var.existing_iam_role == true ? 1 : 0
  name = var.role_name
}

resource "random_string" "external_id" {
  count = var.external_id == "" && var.existing_iam_role == false ? 1 : 0
  length  = 16
  special = false
}

locals {
  create_role = var.existing_iam_role == false || can(data.aws_iam_role.existing[0]) == false
  external_id = (var.trusted_entity_type == "aws_account" && var.existing_iam_role == false ?
  (var.external_id != "" ? var.external_id : random_string.external_id[0].result)
  : null)
}

module "account" {
  count = var.trusted_entity_type == "aws_account" && local.create_role == true ? 1 : 0
  source = "./modules/iam-role-account"
  policy_permissions = var.policy_permissions
  policy_resources = var.policy_resources
  external_id = local.external_id
  max_session_duration = var.max_session_duration
  policy_name = var.policy_name
  principal_account_id = var.principal_account_id
  principal_username = var.principal_username
  role_name = var.role_name
  region = var.region
  create_principal_user = var.create_principal_user
  scalr_managed_principals = var.scalr_managed_principals
}

module "service" {
  count = var.trusted_entity_type == "aws_service" && local.create_role == true ? 1 : 0
  source = "./modules/iam-role-service"
  max_session_duration = var.max_session_duration
  policy_name = var.policy_name
  policy_permissions = var.policy_permissions
  policy_resources = var.policy_resources
  role_name = var.role_name
  region = var.region
}

# need to check if existing role matches trusted entity type
locals {
  type = {
    "aws_account": "AWS",
    "aws_service": "Service",
  }
  is_valid_role = local.create_role ? true : lookup(
    jsondecode(data.aws_iam_role.existing[0].assume_role_policy)["Statement"][0]["Principal"],
    local.type[var.trusted_entity_type]
  ) != null
}

locals {
  iam_role_arn = (local.create_role == false ? data.aws_iam_role.existing[0].arn :
                  (var.trusted_entity_type == "aws_account" ? module.account[0].arn : module.service[0].arn))
  principal_access_key = var.trusted_entity_type == "aws_account" && can(module.account[0]) ? module.account[0].principal_access_key : null
  principal_secret_key = var.trusted_entity_type == "aws_account" && can(module.account[0]) ? module.account[0].principal_secret_key : null
}