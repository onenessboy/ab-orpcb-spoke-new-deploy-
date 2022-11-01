output "id" {
  value = azurerm_synapse_workspace.syn_ws.id
}

output "name" {
  value = azurerm_synapse_workspace.syn_ws.name
}

output "principal_id" {
  value = azurerm_synapse_workspace.syn_ws.identity[0].principal_id
}

