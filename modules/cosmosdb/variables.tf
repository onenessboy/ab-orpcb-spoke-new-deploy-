variable "account_name" {
  type        = string
  description = "CosmosDB Account name"
}

variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location of the resource group"
}

variable "cosmosdb_offer_type" {
    type = string
}

variable "cosmosdb_kind"{
    type = string
}

# variable "subnet_id" {
#   type        = string
#   description = "The ID of HUb subnet where we need to create PE"
# }

variable "cosmosdb_consistancy_level" {
  type = string
}

variable ip_range_filter {
  type = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}