variable "resource_group" {
  type = string  
}

variable "location" {
  type = string
}

variable "locationcode"{
  type = any
  default = {
     westeurope = "we",
     eastus = "eus"
    }
}

variable "env" {
  type = string
}

variable "client_code"{
  type = string
}

variable "charge_code"{
  type = string
}

variable "aad_login_name" {
  type = string
}

variable "aad_login_tenant_id" {
  type = string
}

variable "aad_login_object_id" {
  type = string
}

variable "synadmin_username" {    //TODO - move into synapse_config variable
  type = string
}

variable "synadmin_password" {    //TODO - move into synapse_config variable (possible not needed)
  type = string
  sensitive = true
}

variable "enable_syn_sqlpool" {   //TODO - move into synapse_config variable
  type = string
  description = "Variable to enable or disable Synapse Dedicated SQL pool deployment"
}

variable "enable_syn_sparkpool" { //TODO - move into synapse_config variable
  type = string
  description = "Variable to enable or disable Synapse Spark pool deployment"
}

//TODO - group all synapse/spark related configuration under one object
variable "synapse_config" {
  type = any
  description = "Variable to config synapse and related resources for deployment"
  default = {     //sample
    sparkPool_config ={
      deploy                    = true
      pool_nodesize             = 3
      autoscale_max_node_count  = 50
      autoscale_min_node_count  = 3
      version                   = "3.1"
    }
    sqlPool_config ={
      deploy                    = false
    }
  }
}

variable "CLIENT_CODE" {
  type = string
}

variable "CLIENT_SUBSCRIPTION_ID" {
  type = string
}

variable "kv_sku_name" {
  type = string
}

variable "storage_account_tier" {
  type = string
}

variable "storage_account_replication_type" {
  type = string
}

variable "storage_account_kind" {
  type = string
}

variable "sql_pool_sku_name" {
  type = string
}

variable "node_size_family" {
  type = string
}

variable "spark_pool_nodesize" {
  type = string
}

variable "autoscale_max_node_count" {
  type = string
}

variable "autoscale_min_node_count" {
  type = string
}

resource "random_string" "postfix" {
  length  = 8
  special = false
  upper = false
}

variable "subnet_id" {          //TODO - rename - subnet for ?
  type        = string 
  default = null
}

# variable "syn_zone_sql_id" {
#   type = list(string)
#   default = []
# }

# variable "syn_zone_dev_id" {
#     type = list(string)
#   default = []
# }

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

//TODO - sensitive
// Status = No action requried, its comes from circleci context hnce its already protected
variable "hub_arm_client_secret" {  
  type = string
}

variable  "ARM_TENANT_ID" {
  type = string
}

variable  "ARM_CLIENT_ID" {
  type = string
}

//TODO - sensitive
// Status = No action requried, its comes from circleci context hnce its already protected
variable  "ARM_CLIENT_SECRET" {     
  type = string
}

variable "spark_version" {
  type = string
}

variable "cosmosdb_offer_type" {
    type = string
}

variable "cosmosdb_kind"{
    type = string
}

variable "cosmosdb_consistancy_level" {
  type = string
}

variable ip_range_filter {
  type = string
}

//TODO - rename variable; flat it out as string
// status  = done testing
variable "admins_group" {
  description = "Roles assigned to Admins Group"
  type = string
}

variable "AAD_contributors_group_id" {
  description = "Roles assigned to Contributors Group"
  type = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}