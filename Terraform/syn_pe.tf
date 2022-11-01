locals {
  hub_vnet_name = "vnet-orpcb-hub-${var.env}-${local.location_prefix[coalesce(var.hub_location)]}"
}

module "synapse_workspace_pe" {
  source = "../modules/synapse-pe"
  providers = {
    azurerm.hub = azurerm.hub
  }
  synapse_workspace_name = module.synapse_workspace.name
  synapse_workspace_id   = module.synapse_workspace.id
  syn_kv_name = module.key_vault.name
  syn_kv_id = module.key_vault.id
  hub_config = {
    tenant_id                = var.hub_tenant_id
    subscription_id          = var.hub_subscription_id
    location                 = var.hub_location
    vnet_name                = local.hub_vnet_name
    vnet_resource_group_name = var.hub_rg
    vnet_client_subnet_id    = "/subscriptions/${var.hub_subscription_id}/resourceGroups/${var.hub_rg}/providers/Microsoft.Network/virtualNetworks/${local.hub_vnet_name}/subnets/ClientDataSubnet"
    private_dns_zone_ids = {
      dev = "/subscriptions/${var.hub_subscription_id}/resourceGroups/${var.hub_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.dev.azuresynapse.net"
      sql = "/subscriptions/${var.hub_subscription_id}/resourceGroups/${var.hub_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.sql.azuresynapse.net"
      Vault = "/subscriptions/${var.hub_subscription_id}/resourceGroups/${var.hub_rg}/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
    }
  }

  depends_on = [
    module.synapse_workspace.id,
    module.key_vault.id
  ]
}

output "syn_workspace_pe_info" {
  value = module.synapse_workspace_pe
}
