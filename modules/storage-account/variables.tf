variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location of the resource group"
}

variable "locationcode"{
  type = any
  default = {
     westeurope = "we",
     eastus = "eus"
  }
}

variable "postfix" {
  type        = string
  description = "Postfix for the module name"
}

variable "hns_enabled" {
  type        = bool
  description = "Hierarchical namespaces enabled/disabled"
  default     = false
}

variable "firewall_virtual_network_subnet_ids" {
  default = []
}

variable "firewall_bypass" {
  default = ["None"]
}

variable "private_dns_zone_ids_blob" {
  default = []
}

variable "private_dns_zone_ids_dfs" {
  default = []
}


variable "storage_account_tier" {
  type  = string 
}

variable "storage_account_replication_type" {
  type = string
}

variable "storage_account_kind" {
  type = string
}

variable "env" {
  type = string
}


variable "tags" {
  type        = map(string)
  default     = {
}
  description = "A mapping of tags which should be assigned to the Resource Group"
}

resource "random_string" "postfix" {
  length  = 8
  special = false
  upper = false
}

variable "circleci_agent_range" { 
  default = []
}

variable "client_code" {
  type = string
}

variable "contributors_group" {
  description = "Roles assigned to Contributors Group"
  type = any
  default = { //TODO - remove default values and have them present into the metadata\config per environment
    dev = "b6e27774-d25d-4b74-aa72-f2f63b737735"
    sbx = "aacc215f-6db2-44b1-8fa4-8f3cee61f37f"
    stg = "24847260-7d6d-4d29-ad8c-4132d6ae000a"
    prod = "4da26896-0502-4445-b8ad-f28b33fd90dc"
}
}

variable "admins_group" {
  description = "Roles assigned to Admins Group"
  type = any
  default = {
    dev = "4da26896-0502-4445-b8ad-f28b33fd90dc"
    sbx = "a53b98ae-d384-4248-97a2-f29c0c729899"
    stg = "98c77ec5-f35b-4465-8d52-7712c2213ac3"
    prod = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
}