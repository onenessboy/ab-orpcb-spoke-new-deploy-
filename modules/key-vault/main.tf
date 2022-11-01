# Key Vault with VNET binding and Private Endpoint  - bound to hub vnet, client data vnet

data "azurerm_client_config" "current" {}

locals {
  location_prefix = tomap({
    for k, v in var.locationcode : k => v
  })
}

resource "azurerm_key_vault" "syn_kv" {
  name                       = "kv-orpcb-ws${var.client_code}-${var.env}-${local.location_prefix[coalesce(var.location)]}" //TODO - pass on the name of the KV as variable
  location                   = var.location
  resource_group_name        = var.rg_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.kv_sku_name
  soft_delete_retention_days = 90
  enable_rbac_authorization  = true
  purge_protection_enabled    = true


  network_acls {
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
    bypass                     = "None"
  }

  # identity {
  #   type = "SystemAssigned"
  # }

  tags = var.tags
}

resource "azurerm_role_assignment" "rbac_assignment" {
  scope                = azurerm_key_vault.syn_kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.admins_group[var.env]    //TODO - if admin_group is flatten, the env shouldn't be needed
}

resource "azurerm_role_assignment" "rbac_assignment_reader" {
  scope                = azurerm_key_vault.syn_kv.id
  role_definition_name = "Key Vault Reader"
  principal_id         = var.principal_id
}



//TODO - add azurerm_monitor_diagnostic_setting if feature flag/config provided
//needs to report into hub log analytics + logs storage account