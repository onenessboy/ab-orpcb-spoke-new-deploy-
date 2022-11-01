variable "hub_config" {
  type = any
  default = {
    tenant_id                = ""
    subscription_id          = ""
    location                 = "we"
    vnet_resource_group_name = ""
    vnet_name                = "" // needed for vnet
    vnet_client_subnet_id    = "" // uri for resource (id including subcr)
    private_dns_zone_ids = {
      dev = ""
      sql = ""
      Vault = ""
    }
  }
}

variable "synapse_workspace_name" {
  type = string
}

variable "synapse_workspace_id" {
  type = string
}

variable "syn_kv_name"{
  type = string
}

variable "syn_kv_id"{
  type = string
}