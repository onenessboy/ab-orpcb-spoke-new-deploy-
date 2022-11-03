# Storage Account with VNET binding and Private Endpoints for blob and dfs

data "azurerm_client_config" "current" {}

data "http" "ip" {
  url = "https://ifconfig.me"
}

locals {
    location_prefix = tomap({
        for k, v in var.locationcode : k => v
    })
}

//TODO - reconsider the rename of the module - this can't be applied for regular storage accounts, only for synapse related Delta lake storage accounts
// Status: dont understand this requried ask hora
#--------------------------------------
# Create Storage Account
#-------------------------------------
resource "azurerm_storage_account" "syn_st" {
  name                     = substr("stdl${var.client_code}${var.env}${local.location_prefix[coalesce(var.location)]}${random_string.postfix.result}", 0, 24)
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
  is_hns_enabled           = var.hns_enabled
  tags = local.common_tags
}

#-----------------------------------------
# Roles Assignment
#-----------------------------------------
resource "azurerm_role_assignment" "st_role_admin_c" {
  scope                = azurerm_storage_account.syn_st.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "st_role_admin_sbdc" {
  scope                = azurerm_storage_account.syn_st.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Roles added to Synapse Admins AD group - orpcb-<<env>>-admins
# Roles Added - Storage Blob Data Owner

resource "azurerm_role_assignment" "syn_storage_admin" {
  scope                = azurerm_storage_account.syn_st.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.admins_group[var.env]  
}

# Roles added to Synapse Contibutors AD group - orpcb-<<env>>-contributors
# Roles Added - Storage Blob Data Contributor
resource "azurerm_role_assignment" "syn_storage_cont" {
  scope                = azurerm_storage_account.syn_st.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.contributors_group[var.env]
}

//synapse workspace identity neededs role assignments (see  https://learn.microsoft.com/en-us/azure/synapse-analytics/quickstart-create-workspace#configure-access-to-the-storage-account-from-your-workspace)
//TODO - assign ws identity needed st roles
// Status: this is added already in synapse-workspace module - hence not needed

#-----------------------------------------
# Virtual Network & Firewall configuration
#-----------------------------------------

resource "azurerm_storage_account_network_rules" "firewall_rules" {
  storage_account_id = azurerm_storage_account.syn_st.id
  default_action             = "Allow"
  ip_rules                   = [data.http.ip.body]
}

resource "time_sleep" "wait_180_seconds" {
  depends_on = [azurerm_storage_account_network_rules.firewall_rules]
  create_duration = "180s"
}

#------------------------------------------
# Datalake file system configuration
#-----------------------------------------
resource "azurerm_storage_data_lake_gen2_filesystem" "st_adls" {
  name               = "adls"
  storage_account_id = azurerm_storage_account.syn_st.id

  depends_on = [
    azurerm_role_assignment.st_role_admin_sbdc,
    azurerm_storage_account.syn_st,
    azurerm_storage_account_network_rules.firewall_rules
  ]  
}



