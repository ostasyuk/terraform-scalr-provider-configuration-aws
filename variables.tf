# ------------ Scalr variables -------------- #
variable "scalr_environments" {
  type = list(string)
  description = <<EOT
    The list of environments where created provider configuration is available:
    - empty list means it is not available in any environment
    - "*" - means it is available in all existing and future environments
    - also you can specify the list of the environment names to share the configuration with.
    For the sake of simplicity, the provider configuration is available for any environment by default.
  EOT
  # "*" means the provider configuration will be available for all environments of the account.
  # To limit the environments pass the identifiers.
  default = ["*"]
}

variable "name" {
  type = string
  description = "The provider configuration name."
}

variable "scalr_account_id" {
  type = string
  description = "The Scalr account id."
}

variable "export_shell_variables" {
  description = "Whether the provider configuration values will be exported as shell variables in the run environment."
  type = bool
  default = false
}

# ------------ Scalr variables -------------- #

variable "region" {
  type = string
  default = "us-east-1"
  description = "The region where all AWS resources are deployed"
}

variable "account_type" {
  type = string
  default = "regular"
  description = <<EOT
      The AWS account type. Available options:
      - regular   - account type used by most companies across the world.
      - gov-cloud - account type that provides AWS Services in GovCloud (US) Region
      - cn-cloud  - account type that provides AWS Services in AWS China (Beijing) Region and AWS China (Ningxia) Region
  EOT

  validation {
    condition     = contains(["regular", "gov-cloud", "cn-cloud"], var.account_type)
    error_message = "The \"account_type\" must be one of: \"regular\", \"gov-cloud\", \"cn-cloud\"."
  }
}

variable "trusted_entity_type" {
  type = string
  description = <<EOT
    The AWS trusted entity type of the IAM role. Available options:
    - aws_account - Allow entities in other AWS accounts belonging to you or a 3rd party to perform actions in this account.
    - aws_service - Allow AWS services like EC2, Lambda, or others to perform actions in this account.
  By default, the AWS account trusted entity type is selected.
  EOT

  default = "aws_account"

  validation {
    condition     = contains(["aws_account", "aws_service"], var.trusted_entity_type)
    error_message = "The \"trusted_entity_type\" must be one of: \"aws_account\", \"aws_service\"."
  }
}

variable "external_id" {
  type = string
  description = "The external ID for the AWS account trusted entity type. Leave blank for the auto-generated value."
  default = ""
}

variable "existing_iam_role" {
  type = bool
  description = "Whether user wants to set already created or configured iam role. By default the role is created by module."
  default = false
}

variable "policy_permissions" {
  type = list(string)
  description = <<EOT
    The list of allowed permissions to apply in the IAM policy document.
    By default is an empty list. Required if the role is created by the module.
  EOT
  default = []
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
  default = "ScalrProviderConfigurationPolicy"
}

variable "max_session_duration" {
  type = number
  description = <<EOT
    TTL of temporary credentials. Defaults to default run operation timeout in Scalr.
    Set to the maximum run operation timeout of the workspace in the available environment.
  EOT
  default = 120

  validation {
    condition = var.max_session_duration >= 10 && var.max_session_duration <= 720
    error_message = "Value for \"max_session_duration\" cannot be less than 10 minutes and more than 720 minutes."
  }
}

variable "principal_account_id" {
  type = string
  description = "The principal AWS account id that is allowed to assume the role. Default: Scalr managed AWS account id."
  default = "919814621061"
}

variable "principal_username" {
  type = string
  description = "The principal AWS user that is allowed to assume the role. Default: Scalr managed AWS user"
  default = "scalr-saas"
}

variable "create_principal_user" {
  type = bool
  description = "Whether to create a principal user. By default, the existing user is taken"
  default = false
}

variable "scalr_managed_principals" {
  type = bool
  description = "Whether a principal user is managed by Scalr. By default, the user is managed by Scalr"
  default = true
}