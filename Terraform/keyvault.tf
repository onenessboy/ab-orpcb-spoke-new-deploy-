module "key_vault" {
  source = "../modules/key-vault"

  //TODO - pass on the name of the KV as variable
  rg_name  = module.resource_group.name
  location = module.resource_group.location
  postfix = random_string.postfix.result
  kv_sku_name = var.kv_sku_name
  //TODO - remove client_code var as not needed in the module
  // Status : we need this as we are using clientcode as part of KV name
  client_code = var.client_code
  //TODO - remove
  // Status -- We need this as we are using it in name of KV       
  locationcode = var.locationcode
   //TODO - remove env var as not needed in the module
   // status: -- We need this as we are using it in name of KV 
  env = var.env                      
  principal_id = module.synapse_workspace.principal_id
 
 //TODO - flaten this out as the module should need to know the environment
  # admins_group = {    
  #   dev = var.admins_group
  #   sbx = var.admins_group
  #   stg = var.admins_group
  # }
  admins_group = var.admins_group
//TODO - replace with local.common_tags
// status: In testing
  tags = local.common_tags 
} 