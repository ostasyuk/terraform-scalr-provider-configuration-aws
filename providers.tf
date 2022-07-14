terraform {
  required_providers {
    scalr = {
      # TODO: replace to production registry after the release.
      source = "registry.scalr.dev/scalr/scalr"
      version= "1.0.0-rc-develop"
    }
  }
}

provider "aws" {
  region = var.region
}