# ------------------------
# Resource group creation
# -----------------------


locals {
  location_prefix = tomap({
    for k, v in var.locationcode : k => v
  })
}
resource "azurerm_resource_group" "syn_rg" {
  name     = "rg-orpcb-${var.client_code}-${var.env}-${local.location_prefix[coalesce(var.location)]}"
  location = var.location
  tags = local.common_tags
}