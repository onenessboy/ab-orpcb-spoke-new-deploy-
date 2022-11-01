terraform {
  backend "azurerm" {} #commnent out for local run; uncomment for CircleCI
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.21.1"
    }
  }
}

provider "azurerm" {
  subscription_id = var.CLIENT_SUBSCRIPTION_ID
  tenant_id       = var.ARM_TENANT_ID
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  features {}
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = var.hub_subscription_id
  tenant_id       = var.hub_tenant_id
  client_id       = var.hub_arm_client_id
  client_secret   = var.hub_arm_client_secret
  features {}
}

data "azurerm_client_config" "current" {}

data "http" "ip" {
  url = "https://ifconfig.me"
}


locals {
  product_id        = 14520
  charge_code       = var.charge_code
  atlas_tenant_code = var.client_code //TODO - check if we need this to be place into variables (to be added to client config)
  common_tags = merge(var.tags,
    { "product_id" = local.product_id },
    { "charge_code" = local.charge_code },
    { "atlas_tenant_code" = local.atlas_tenant_code },
    { "environment" = var.env },
    { "client_code" = var.client_code },
  { "used_for" = (var.env == "prod") ? "prod" : "non_prod" })
}

locals {
  location_prefix = tomap({
    for k, v in var.locationcode : k => v
  })
}
