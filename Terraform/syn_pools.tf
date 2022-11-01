
# Dedicated SQL pool
module "synapse_dedicated_sql_pool" {
  source = "../modules/synapse-pools"
  postfix              = random_string.postfix.result
  synapse_workspace_id = module.synapse_workspace.id
  sql_pool_sku_name = var.sql_pool_sku_name
  node_size_family     = var.node_size_family
  spark_pool_nodesize  = var.spark_pool_nodesize
  autoscale_max_node_count = var.autoscale_max_node_count
  autoscale_min_node_count = var.autoscale_min_node_count
  enable_syn_sqlpool = var.enable_syn_sqlpool
  spark_version = var.spark_version

  #tags = local.common_tags  //TODO - add tags to module
}

# Spark pool
module "synapse_spark_pool" {
  source = "../modules/synapse-pools"
  postfix              = random_string.postfix.result
  synapse_workspace_id = module.synapse_workspace.id
  sql_pool_sku_name    = var.sql_pool_sku_name
  node_size_family     = var.node_size_family
  spark_pool_nodesize  = var.spark_pool_nodesize
  autoscale_max_node_count = var.autoscale_max_node_count
  autoscale_min_node_count = var.autoscale_min_node_count
  enable_syn_sparkpool = var.enable_syn_sparkpool
  spark_version = var.spark_version

  #tags = local.common_tags   //TODO - add tags to module
}

