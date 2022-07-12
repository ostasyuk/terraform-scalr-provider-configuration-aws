variable "region" {
  type = string
  default = "us-east-1"
}

variable "policy_permissions" {
  type = list(string)
  description = "A coma-separated list of permissions"
}

variable "policy_resources" {
  type = list(string)
  default =  ["*"]
}

variable "role_name" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "max_session_duration" {
  type = number
  description = "TTL of temporary credentials. Defaults to default run operation timeout in Scalr."

  validation {
    condition = var.max_session_duration >= 10 && var.max_session_duration <= 720
    error_message = "Value for \"max_session_duration\" cannot be less than 10 minutes and more than 720 minutes."
  }
}

variable "principal_account_id" {
  type = string
  description = "The principal AWS account id that is allowed to assume the role."
}

variable "principal_username" {
  type = string
  description = "The principal AWS user that is allowed to assume the role."
}

variable "external_id" {
  type = string
}
