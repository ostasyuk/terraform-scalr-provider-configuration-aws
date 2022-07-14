variable "region" {
  type = string
  default = "us-east-1"
  description = "The region where all AWS resources are deployed"
}

variable "policy_permissions" {
  type = list(string)
  description = <<EOT
    The list of allowed permissions to apply in the IAM policy document.
    By default is an empty list. Required if the role is created by the module.
  EOT

  validation {
    condition = length(var.policy_permissions) > 0
    error_message = "The list of \"policy_permissions\" cannot be empty. At least one permission is required."
  }
}

variable "policy_resources" {
  type = list(string)
  description = "The list of allowed resources to apply in the IAM policy document. All resources are allowed by default."
  default =  ["*"]
}

variable "role_name" {
  type = string
  description = "The IAM role to retrieve or crate in the AWS account."
}

variable "policy_name" {
  type = string
  description = "The IAM role policy to crate in the AWS account. Used only if the role is created by the module."
}

variable "max_session_duration" {
  type = number
   description = <<EOT
    TTL of temporary credentials. Defaults to default run operation timeout in Scalr.
    Set to the maximum run operation timeout of the workspace in the available environment.
  EOT

  validation {
    condition = var.max_session_duration >= 10 && var.max_session_duration <= 720
    error_message = "Value for \"max_session_duration\" cannot be less than 10 minutes and more than 720 minutes."
  }
}

variable "principal_account_id" {
  type = string
  description = "The principal AWS account id that is allowed to assume the role. Default: Scalr managed AWS account id."
}

variable "principal_username" {
  type = string
  description = "The principal AWS user that is allowed to assume the role. Default: Scalr managed AWS user"
}

variable "external_id" {
  type = string
  description = "The external ID for the AWS account trusted entity type. Leave blank for the auto-generated value."
}

variable "create_principal_user" {
  type = bool
  description = "Whether the principal user is a Scalr-managed one"
  default = true
}

variable "scalr_managed_principals" {
  type = bool
  description = "Whether a principal user is managed by Scalr. By default, the user is managed by Scalr"
  default = false
}