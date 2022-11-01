//TODO - add name variable

variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location of the resource group"
}

variable "locationcode"{    //TODO - remove as can be avoided/not needed in the module if the name is passed on
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

# variable "vnet_id" {  //TODO - clean up comments if not used  //
#   type        = string
#   description = "The ID of the vnet that should be linked to the DNS zone"
# }

# variable "subnet_id" {
#   type        = string
#   description = "The ID of the subnet from which private IP addresses will be allocated for this Private Endpoint"
# }

variable "kv_sku_name" {
  type        = string
  description = "Key vault sku name"
}

variable "client_code" {
  type = string
}

variable "env" {
  type = string
}

variable "admins_group" {
  description = "Roles assigned to Admins Group"
  type = any
  default = { //TODO - remove default values and have them present into the metadata\config per environment
    dev = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    sbx = "a53b98ae-d384-4248-97a2-f29c0c729899"
    stg = "98c77ec5-f35b-4465-8d52-7712c2213ac3"
    prod = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "principal_id" {
  //TODO - add description field with description for what principal_id is
  type = string
}

//TODO - add variables for azure monitoring settings (include) feature/deploy flag