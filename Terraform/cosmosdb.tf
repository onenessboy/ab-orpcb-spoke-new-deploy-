module "cosmosdb" {  
  source = "../modules/cosmosdb"
  account_name = "cosmos-orpcb-ws${var.client_code}-${var.env}-${local.location_prefix[coalesce(var.location)]}"
  rg_name  = module.resource_group.name
  location = module.resource_group.location
  cosmosdb_offer_type = var.cosmosdb_offer_type
  cosmosdb_kind = var.cosmosdb_kind
  ip_range_filter = var.ip_range_filter
  #subnet_id = var.subnet_id
  cosmosdb_consistancy_level = var.cosmosdb_consistancy_level
  tags = local.common_tags
}