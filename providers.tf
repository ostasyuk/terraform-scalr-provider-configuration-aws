terraform {
  required_providers {
    scalr = {
      source = "registry.scalr.io/scalr/scalr"
      version= "1.0.0-rc32"
    }
  }
}

provider "aws" {
  region = var.region
}