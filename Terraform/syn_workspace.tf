module "synapse_workspace" {
  source = "../modules/synapse-workspace"
  #providers = {      
    #azurerm = azurerm
    #azurerm.hub = azurerm.hub
  #}
  rg_name  = module.resource_group.name
  location = module.resource_group.location
  postfix = random_string.postfix.result
  env = var.env                     //TODO remove the env variable; module doesn't need to know the env
  client_code = var.client_code
  charge_code = var.charge_code
  workspace_name = "syn-orpcb-ws${var.client_code}-${var.env}-${local.location_prefix[coalesce(var.location)]}"
  subnet_id = var.subnet_id
  hub_location = var.hub_location
  hub_rg = var.hub_rg
  hub_subscription_id = var.hub_subscription_id
  hub_tenant_id = var.hub_tenant_id
  hub_arm_client_id = var.hub_arm_client_id
  hub_arm_client_secret = var.hub_arm_client_secret
  adls_id              = module.storage_account.adls_id
  storage_account_id   = module.storage_account.id
  storage_account_name = module.storage_account.name
  synadmin_username = var.synadmin_username
  synadmin_password = var.synadmin_password
  locationcode = var.locationcode

  admins_group = {    //TODO - flaten this out as the module should need to know the environment
    dev = var.admins_group
    sbx = var.admins_group
    stg = var.admins_group
  }
  contributors_group = {
    dev = var.contributors_group
    sbx = var.contributors_group
    stg = var.contributors_group
  }

  tags = local.common_tags

  aad_login = {
    aad_login_name = var.aad_login_name
    aad_login_object_id = var.aad_login_object_id
    aad_login_tenant_id = var.aad_login_tenant_id
  }
}

output "syn_workspace_info" {  
  value = module.synapse_workspace
}


