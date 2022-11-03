# Azure Synapse Workspace 

data "azurerm_client_config" "current" {}

data "http" "ip" {
  url = "https://ifconfig.me"
}

#----------------------------------------
# Synapse workspace section
#----------------------------------------
resource "azurerm_synapse_workspace" "syn_ws" {
  provider = azurerm
  name                                 = var.workspace_name
  resource_group_name                  = var.rg_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = var.adls_id
  sql_administrator_login          = var.synadmin_username
  #sql_administrator_login_password = var.synadmin_password 
  //TODO - check if we can generate on the fly; we will either way use the aad admin group hence no need to pass on as param (secret)     
  // Status : In Testing
  sql_administrator_login_password = var.random_string.postfix.result

  managed_virtual_network_enabled = true
  managed_resource_group_name     = "${var.rg_name}-syn-managed"
  public_network_access_enabled = true                          //TODO - change to false; private access only

  aad_admin {
    login     = var.aad_login.aad_login_name
    object_id = var.aad_login.aad_login_object_id
    tenant_id = var.aad_login.aad_login_tenant_id
  }
  # added below mandatory identity as per 3.21.1 azurerm
  identity {
    type = "SystemAssigned"
  }
  
  tags = local.common_tags
}

#-----------------------------------------------
# Virtual Network & Firewall configuration
#-----------------------------------------------
resource "azurerm_synapse_firewall_rule" "allow_my_ip" {
  provider = azurerm
  name                 = "AllowCI_TF_PublicIp"
  synapse_workspace_id = azurerm_synapse_workspace.syn_ws.id
  start_ip_address     = data.http.ip.body
  end_ip_address       = data.http.ip.body
  depends_on = [azurerm_synapse_workspace.syn_ws]
}

resource "time_sleep" "wait_180_seconds" {
  depends_on = [azurerm_synapse_workspace.syn_ws, azurerm_synapse_firewall_rule.allow_my_ip]
  create_duration = "200s"
}
#------------------------------------------------
# Role assignment 
#------------------------------------------------
resource "azurerm_role_assignment" "syn_ws_sa_role_si_sbdc" {
  provider = azurerm
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_synapse_workspace.syn_ws.identity[0].principal_id
  depends_on = [azurerm_synapse_firewall_rule.allow_my_ip]  
}


# Roles added to Contributors AD group  - orpcb-<<env>>-contributors;  
# Roles Added - Storage //TODO - move towards the Data Lake Storage Gen2 module, maybe? isn't related to WS
// Status: No action reuried these roles related to workspace and storage, we can have it here
#--------------------------------------------------------
resource "azurerm_role_assignment" "syn_ws_sa_role_syncontr1" {
  provider = azurerm
  scope                = var.storage_account_id         //TODO - move towards st module
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.AAD_contributors_group_id
  depends_on = [azurerm_synapse_firewall_rule.allow_my_ip]
}

//TODO - move towards the Data Lake Storage Gen2 module, maybe? isn't related to WS;  
//Status: No action reuried these roles related to workspace and storage, we can have it here

//TODO - cleanup maybe?! Contributor shouldn't be needed as they shouldn't be able to change the storage account properties
// Status: Ujwal has requested me to put all these roles, we need confirm with him before we clean up
resource "azurerm_role_assignment" "syn_ws_sa_role_syncontr2" {
  provider = azurerm
  scope                = var.storage_account_id         
  role_definition_name = "Contributor"
  principal_id         = var.AAD_contributors_group_id
  depends_on = [azurerm_synapse_firewall_rule.allow_my_ip]
}

resource "azurerm_synapse_role_assignment" "syn_ws_sa_role_syncontr3" {
  synapse_workspace_id = azurerm_synapse_workspace.syn_ws.id
  role_name            = "Synapse Contributor"
  principal_id         = var.AAD_contributors_group_id
  depends_on = [azurerm_synapse_firewall_rule.allow_my_ip]  
}

resource "azurerm_synapse_role_assignment" "syn_ws_sa_role_syncontr4" {
  synapse_workspace_id = azurerm_synapse_workspace.syn_ws.id
  role_name            = "Synapse Credential User"
  principal_id         = var.AAD_contributors_group_id
  depends_on = [azurerm_synapse_firewall_rule.allow_my_ip]
}

resource "azurerm_synapse_role_assignment" "syn_ws_sa_role_syncontr5" {
  synapse_workspace_id = azurerm_synapse_workspace.syn_ws.id
  role_name            = "Synapse Artifact User"
  principal_id         = var.AAD_contributors_group_id
  depends_on = [azurerm_synapse_firewall_rule.allow_my_ip]
}

#--------------------------------------------------------
# Roles added to Synapse Admins AD group for  - orpcb-<<env>>-admins
# Roles Added - Synapse Administrator, Synapse SQL Administrator, Synapse Apache Spark Administrator,Synapse Artifact Publisher, Synapse Linked Data Manager
#--------------------------------------------------------

resource "azurerm_synapse_role_assignment" "syn_ws_sa_role_synadmin1" {
  synapse_workspace_id = azurerm_synapse_workspace.syn_ws.id
  role_name            = "Synapse Administrator"
  principal_id         = var.AAD_admins_group_id
  depends_on = [azurerm_synapse_firewall_rule.allow_my_ip]
}
resource "azurerm_synapse_role_assignment" "syn_ws_sa_role_synadmin2" {
  synapse_workspace_id = azurerm_synapse_workspace.syn_ws.id
  role_name            = "Synapse SQL Administrator"
  principal_id         = var.AAD_admins_group_id
  depends_on = [azurerm_synapse_firewall_rule.allow_my_ip]
}
resource "azurerm_synapse_role_assignment" "syn_ws_sa_role_synadmin3" {
  synapse_workspace_id = azurerm_synapse_workspace.syn_ws.id
  role_name            = "Apache Spark Administrator"
  principal_id         = var.AAD_admins_group_id
  depends_on = [azurerm_synapse_firewall_rule.allow_my_ip]
}
resource "azurerm_synapse_role_assignment" "syn_ws_sa_role_synadmin4" {
  synapse_workspace_id = azurerm_synapse_workspace.syn_ws.id
  role_name            = "Synapse Artifact Publisher"
  principal_id         = var.AAD_admins_group_id
  depends_on = [azurerm_synapse_firewall_rule.allow_my_ip]
}
resource "azurerm_synapse_role_assignment" "syn_ws_sa_role_synadmin5" {
  synapse_workspace_id = azurerm_synapse_workspace.syn_ws.id
  role_name            = "Synapse Linked Data Manager"
  principal_id         = var.AAD_admins_group_id
  depends_on = [azurerm_synapse_firewall_rule.allow_my_ip]
}




