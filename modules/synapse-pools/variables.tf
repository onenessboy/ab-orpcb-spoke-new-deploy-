variable "postfix" {
  type        = string
  default     = "001"
  description = "Postfix for the module name"
}

variable "synapse_workspace_id" {
  type        = string
  description = "The ID of the Synapse workspace"
}

variable "enable_syn_sqlpool" {
  description = "Variable to enable or disable Synapse Dedicated SQL pool deployment"
  default     = false
}

variable "enable_syn_sparkpool" {
  description = "Variable to enable or disable Synapse Spark pool deployment"
  default     = false
}

variable "sql_pool_sku_name" {
  description = "Variable to define sku type of sql pool"
  type = string
}

variable "node_size_family" {
  description = "Variable to define node size family of spark pool"
  type = string
}

variable "spark_pool_nodesize" {
  description = "Variable to define spark pool node size"
  type = string
}

variable "autoscale_max_node_count" {
  description = "Variable to define spark pool node size"
  type = string
}

variable "autoscale_min_node_count" {
  description = "Variable to define spark pool node size"
  type = string
}

variable "spark_version" {
  type = string
}