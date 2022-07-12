variable "region" {
  type = string
  default = "us-east-1"
}

variable "credentials_type" {
  type = string
  default = "role_delegation"
}

variable "account_type" {
  type = string
  default = "regular"
}

variable "trusted_entity_type" {
  type = string
  default = "aws_account"
}

variable "scalr_environments" {
  type = list(string)
  # "*" means the provider configuration will be available for all environments of the account.
  # To limit the environments pass the identifiers.
  default = ["*"]
}

variable "name" {
  type = string
}

variable "scalr_account_id" {
  type = string
}

variable "external_id" {
  type = string
  default = ""
}

resource "random_string" "external_id" {
  count = var.external_id == "" ? 1 : 0
  length  = 16
  special = false
}

locals {
  external_id = var.external_id != "" ? var.external_id : random_string.external_id[0].result
}

variable "existing_iam_role" {
  type = bool
  default = false
}

variable "policy_permissions" {
  type = list(string)
  default = []
  description = "A coma-separated list of permissions"
}

variable "policy_resources" {
  type = list(string)
  default =  ["*"]
}

variable "role_name" {
  type = string
  default = "ScalrIntegrationRole"
}

variable "policy_name" {
  type = string
  default = "ScalrProviderConfigurationPolicy"
}

variable "max_session_duration" {
  type = number
  description = "TTL of temporary credentials. Defaults to default run operation timeout in Scalr."
  default = 120

  validation {
    condition = var.max_session_duration >= 10 && var.max_session_duration <= 720
    error_message = "Value for \"max_session_duration\" cannot be less than 10 minutes and more than 720 minutes."
  }
}

variable "principal_account_id" {
  type = string
  default = "919814621061"
  description = "The principal AWS account id that is allowed to assume the role. Default: Scalr managed AWS account"
}

variable "principal_username" {
  type = string
  default = "scalr-saas"
  description = "The principal AWS user that is allowed to assume the role. Default: Scalr managed AWS user"
}
