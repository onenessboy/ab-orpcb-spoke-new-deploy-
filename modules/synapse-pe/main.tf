# Azure Synapse Workspace private endpoints

data "azurerm_client_config" "current" {}

data "http" "ip" {
  url = "https://ifconfig.me"
}

# Creating Private Endpoints for synapse
resource "azurerm_private_endpoint" "syn_ws_pe_dev" {
  provider            = azurerm.hub
  name                = "pe-${var.synapse_workspace_name}-dev"
  location            = var.hub_config.location
  resource_group_name = var.hub_config.vnet_resource_group_name
  subnet_id           = var.hub_config.vnet_client_subnet_id

  private_service_connection {
    name                           = "psc-syn-ws-${var.synapse_workspace_name}"
    private_connection_resource_id = var.synapse_workspace_id
    subresource_names              = ["dev"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-dev"
    private_dns_zone_ids = [var.hub_config.private_dns_zone_ids["dev"]]
  }
}

resource "azurerm_private_endpoint" "syn_ws_pe_sql" {
  provider            = azurerm.hub
  name                = "pe-${var.synapse_workspace_name}-sql"
  location            = var.hub_config.location
  resource_group_name = var.hub_config.vnet_resource_group_name
  subnet_id           = var.hub_config.vnet_client_subnet_id

  private_service_connection {
    name                           = "psc-${var.synapse_workspace_name}-sql"
    private_connection_resource_id = var.synapse_workspace_id
    subresource_names              = ["sql"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-sql"
    private_dns_zone_ids = [var.hub_config.private_dns_zone_ids["sql"]]
  }
}

resource "azurerm_private_endpoint" "syn_ws_pe_sqlondemand" {
  provider            = azurerm.hub
  name                = "pe-${var.synapse_workspace_name}-sqlondemand"
  location            = var.hub_config.location
  resource_group_name = var.hub_config.vnet_resource_group_name
  subnet_id           = var.hub_config.vnet_client_subnet_id

  private_service_connection {
    name                           = "psc-${var.synapse_workspace_name}-sqlondemand"
    private_connection_resource_id = var.synapse_workspace_id
    subresource_names              = ["sqlondemand"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-sqlondemand"
    private_dns_zone_ids = [var.hub_config.private_dns_zone_ids["sql"]]
  }
}

# add kv PE on hub (private network manged by Synapse)

resource "azurerm_private_endpoint" "kv_pe" {
  provider            = azurerm.hub
  name                = "pe-${var.syn_kv_name}"
  location            = var.hub_config.location
  resource_group_name = var.hub_config.vnet_resource_group_name
  subnet_id           = var.hub_config.vnet_client_subnet_id

  private_service_connection {
    name                           = "psc-${var.syn_kv_name}"
    private_connection_resource_id = var.syn_kv_id
    subresource_names = ["Vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-kv"
    private_dns_zone_ids = [var.hub_config.private_dns_zone_ids["Vault"]]
  }
}