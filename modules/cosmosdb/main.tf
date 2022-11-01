resource "azurerm_cosmosdb_account" "cosmosaccount" {
  name                = var.account_name
  location            = var.location
  resource_group_name = var.rg_name  
  offer_type          = var.cosmosdb_offer_type
  kind                = var.cosmosdb_kind
  is_virtual_network_filter_enabled = "true"
  ip_range_filter     = var.ip_range_filter
  enable_automatic_failover = false

  consistency_policy {
    consistency_level       = var.cosmosdb_consistancy_level
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  # virtual_network_rule  {
  #   id                = var.subnet_id
  #   ignore_missing_vnet_service_endpoint = true
  # }
  tags     = var.tags
}


resource "azurerm_cosmosdb_sql_database" "comosdbsqldb" {
  name                = "driving"
  resource_group_name = azurerm_cosmosdb_account.cosmosaccount.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosaccount.name
  throughput          = 500   
  depends_on = [azurerm_cosmosdb_account.cosmosaccount]  
}


resource "azurerm_cosmosdb_sql_container" "mdhistcontainer" {
  name                  = "metadata_history"
  resource_group_name   = azurerm_cosmosdb_account.cosmosaccount.resource_group_name
  account_name          = azurerm_cosmosdb_account.cosmosaccount.name
  database_name         = azurerm_cosmosdb_sql_database.comosdbsqldb.name
  partition_key_path    = "/definition/id"
  partition_key_version = 1
  throughput            = 500

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }

  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
  depends_on = [azurerm_cosmosdb_sql_database.comosdbsqldb]
}

resource "azurerm_cosmosdb_sql_container" "mdcontainer" {
  name                  = "metadata"
  resource_group_name   = azurerm_cosmosdb_account.cosmosaccount.resource_group_name
  account_name          = azurerm_cosmosdb_account.cosmosaccount.name
  database_name         = azurerm_cosmosdb_sql_database.comosdbsqldb.name
  partition_key_path    = "/definition/id"
  partition_key_version = 1
  throughput            = 500

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }

  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
  depends_on = [azurerm_cosmosdb_sql_database.comosdbsqldb]
}

