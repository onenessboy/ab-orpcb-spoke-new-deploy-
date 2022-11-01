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

variable "env" {
  type = string
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

variable "contributors_group" { //TODO - rename for AAD_contributors_group_id maybe?
  description = "Roles assigned to Contributors Group"
  type = any
  default = {   //TODO - remove default values and have them present into the metadata\config per environment
    dev = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    sbx = "aacc215f-6db2-44b1-8fa4-8f3cee61f37f"
    stg = "24847260-7d6d-4d29-ad8c-4132d6ae000a"
    prod = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
}

variable "admins_group" {
  description = "Roles assigned to Admins Group"
  type = any    //TODO - change to string, rename variable name (see above)
  default = {   //TODO - remove default values and have them present into the metadata\config per environment
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