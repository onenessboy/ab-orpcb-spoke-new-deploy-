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


variable "adls_id" {
  type        = string
  description = "The ID of the adls associated with the syn workspace"
}

variable "storage_account_id" {
  type        = string
  description = "The ID of the storage account associated with the syn workspace"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account associated with the syn workspace"
}


variable "synadmin_username" {
  type        = string
  description = "The Login Name of the SQL administrator"
}

variable "synadmin_password" {
  type        = string
  description = "The Password associated with the sql_administrator_login for the SQL administrator"
}

variable "aad_login" {
  description = "AAD login"
  type = object({
    aad_login_name  = string
    aad_login_object_id = string
    aad_login_tenant_id = string
  })
}


variable "client_code" {
  type = string
}

variable "charge_code" {
  type = string
}

variable "workspace_name" {
  type = string
}

variable "subnet_id" {
  type        = string
  description = "The ID of HUb subnet where we need to create PE"
}

variable "syn_zone_sql_id" {
    type = list(string)
  default = []
}

variable "syn_zone_dev_id" {
    type = list(string)
  default = []
}

variable "hub_location" {
  type = string
}

variable "hub_rg" {
  type = string
}

variable "hub_subscription_id" {
  type = string
}

variable "hub_tenant_id" {
  type = string
}

variable "hub_arm_client_id" {
  type = string
}

variable "hub_arm_client_secret" {
  type = string
}

//TODO - rename for AAD_contributors_group_id maybe?
// status : done, in testing
//TODO - remove default values and have them present into the metadata\config per environment
// status -- done
variable "AAD_contributors_group_id" { 
  description = "Roles assigned to Contributors Group"
  type = string
}

//TODO - change to string, rename variable name (see above)
// status -- done in testing
//TODO - remove default values and have them present into the metadata\config per environment
variable "AAD_admins_group_id" {
  description = "Roles assigned to Admins Group"
  type = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}