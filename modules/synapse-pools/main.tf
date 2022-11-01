# Synapse pools with feature flags, change variable values to enable those (false by default)

#-------------------------------------------
# Sql Pool
#------------------------------------------- 
resource "azurerm_synapse_sql_pool" "syn_syndp" {
  name                 = "sqlPool"
  synapse_workspace_id = var.synapse_workspace_id
  sku_name             = var.sql_pool_sku_name
  create_mode          = "Default"
  count                = var.enable_syn_sqlpool ? 1 : 0
}

#--------------------------------------------
# Spark Pool 
#--------------------------------------------
resource "azurerm_synapse_spark_pool" "syn_synsp" {
  name                 = "sparkPool"
  synapse_workspace_id = var.synapse_workspace_id
  node_size_family     = var.node_size_family
  node_size            = var.spark_pool_nodesize
  spark_version        = var.spark_version
  count                = var.enable_syn_sparkpool ? 1 : 0

  auto_scale {
    max_node_count = var.autoscale_max_node_count
    min_node_count = var.autoscale_min_node_count
  }

  auto_pause {
    delay_in_minutes = 15
  }
}