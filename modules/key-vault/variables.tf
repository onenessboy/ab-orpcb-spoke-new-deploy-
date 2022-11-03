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

 //TODO - remove default values and have them present into the metadata\config per environment
 // status : done, now it is part of env.json
variable "admins_group" {
  description = "Roles assigned to Admins Group"
  type = any
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

//TODO - add description field with description for what principal_id is
// status: complete
variable "principal_id" {
  description = "Principal id of workspace identity"
  type = string
}

//TODO - add variables for azure monitoring settings (include) feature/deploy flag
// Status - Pending