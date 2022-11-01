module "key_vault" {
  source = "../modules/key-vault"

  //TODO - pass on the name of the KV as variable
  rg_name  = module.resource_group.name
  location = module.resource_group.location
  postfix = random_string.postfix.result
  kv_sku_name = var.kv_sku_name
  client_code = var.client_code       //TODO - remove client_code var as not needed in the module
  locationcode = var.locationcode     //TODO - remove
  env = var.env                       //TODO - remove env var as not needed in the module
  principal_id = module.synapse_workspace.principal_id
 
  admins_group = {    //TODO - flaten this out as the module should need to know the environment
    dev = var.admins_group
    sbx = var.admins_group
    stg = var.admins_group
  }

  tags = var.tags   //TODO - replace with local.common_tags
} 