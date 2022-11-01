module "storage_account" {
  source = "../modules/storage-account"
  rg_name  = module.resource_group.name
  location = module.resource_group.location
  env = var.env
  client_code = var.client_code
  storage_account_tier = var.storage_account_tier
  storage_account_replication_type = var.storage_account_replication_type
  storage_account_kind = var.storage_account_kind
  postfix = random_string.postfix.result
  locationcode = var.locationcode
  hns_enabled                         = true
  firewall_bypass                     = ["None"]
  firewall_virtual_network_subnet_ids = []

  tags = local.common_tags
}

