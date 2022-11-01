# ------------------------
# Resource group creation
# -----------------------


locals {
  location_prefix = tomap({
    for k, v in var.locationcode : k => v
  })
}
resource "azurerm_resource_group" "syn_rg" {
  # Reverting back to original naming convention
  name     = "rg-orpcb-${var.client_code}-${var.env}-${local.location_prefix[coalesce(var.location)]}"
  location = var.location
  tags     = var.tags
}