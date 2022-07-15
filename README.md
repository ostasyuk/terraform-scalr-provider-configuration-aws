Scalr provider configuration AWS
================================

Features
--------

- Creates a provider configuration with the existing AWS IAM role.

- Creates a provider configuration with the module-created role. The role can have the following trusted entities types:

  - AWS account - Allow entities in other AWS accounts belonging to you or a 3rd party to perform actions in this account.
  - AWS service - Allow AWS services like EC2 to perform actions in this account.
  
- Custom IAM policy documents for the module-created IAM roles.

- All AWS regions (including Gov cloud and China) are supported

- Sharing a provider configuration in all or selected Scalr environments.

- Self-managed or auto-generated external identifiers for AWS account trusted entities.


Usage
-----

Before you start, please authorize [Scalr](https://docs.scalr.com/en/latest/scalr-terraform-provider/index.html#authentication) and [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration) providers.
The basic usage of the module. It will create a configuration with the existing role:

```hcl
module "existing-configuration" {
  source = "github.com/Scalr/terraform-scalr-provider-configuration-aws"
  
  # required parameters:
  name = "scalr-managed-aws-account-configuration"
  role_name = "ExistingIAMRoleName"
  scalr_account_id = "acc-1234567"
  
  # creates with existing role
  existing_iam_role = true
  external_id = "randomString1234"
  
  # To share the configuration with environments set their names, to share for all - set ["*"]
  scalr_environments = ["TeamA-Prod", "TeamA-Dev"] 
}
```

Creates a provider configuration with the module-created IAM role with the trusted entity type AWS account (managed by Scalr):

```hcl
module "aws-account-scalr-configuration" {
  source = "github.com/Scalr/terraform-scalr-provider-configuration-aws"
  
  name = "scalr-managed-aws-account-configuration"
  role_name = "ScalrProviderConfiguration"
  scalr_account_id = "acc-1234567"
  
  # policy permissions are required for the module-created role
  policy_permissions = ["ec2:*"]
}
```

Creates a provider configuration with the module-created IAM role with the trusted entity type AWS account (managed by user):

```hcl
module "aws-account-user--configuration" {
  source = "github.com/Scalr/terraform-scalr-provider-configuration-aws"
  
  name = "scalr-managed-aws-account-configuration"
  role_name = "ScalrProviderConfiguration"
  scalr_account_id = "acc-1234567"

  # User-managed principals
  scalr_managed_principals = false
  create_principal_user = true # set to false if a user exists 
  principal_username = "custom-username"
  
  # policy permissions are required for the module-created role
  policy_permissions = ["ec2:*"]
}
```

Creates a provider configuration with the module-created IAM role with the trusted entity type AWS service:

```hcl
module "aws-account-scalr-configuration" {
  source = "github.com/Scalr/terraform-scalr-provider-configuration-aws"
  
  name = "scalr-managed-aws-account-configuration"
  role_name = "ScalrProviderConfiguration"
  scalr_account_id = "acc-1234567"
  
  policy_permissions = ["ec2:*"]
  
  # set trusted_entity_type to "aws_service". It is available only for on-premise Scalr and Scalr Agents on AWS.
  trusted_entity_type = "aws_service"
}
```

Creates a provider configuration with the module-created IAM role with the trusted entity type AWS service in the Gov Cloud Region:

```hcl
module "aws-account-scalr-configuration" {
  source = "github.com/Scalr/terraform-scalr-provider-configuration-aws"
  
  name = "scalr-managed-aws-account-configuration"
  role_name = "ScalrProviderConfiguration"
  scalr_account_id = "acc-1234567"
  
  # policy permissions are required for the module-created role
  policy_permissions = ["ec2:*"]
  trusted_entity_type = "aws_service"

  # set the account_type to "gov-cloud", for the China Cloud Region set "cn-cloud". 
  # Currently, only "aws_service" trusted_entity_type is supported for Gov and China regions on Scalr SaaS
  account_type = "gov-cloud"
}
```

To make created provider configuration as the default one in an environment add the following:

```hcl
resource "scalr_environment" "test" {
  name = "TeamA-dev"
  default_provider_configuration = [module.existing-configuration.configuration_id] 
}
```

To use created provider configuration in the workspaces add the following:

```hcl
resource "scalr_workspace" "test" {
  name = "test"
  environment = "env-1234567c"

  provider_configuration {
    id = module.existing-configuration.configuration_id
    # alias = "west" # uncomment if you have more than one AWS provider in the workspace
  }
}
```
