module "resource_group" {
  source   = "../modules/resource-group"
  env = var.env
  location = var.location
  client_code = var.client_code
  locationcode = var.locationcode
  tags     = local.common_tags
}