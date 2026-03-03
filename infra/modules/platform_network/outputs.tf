output "resource_group_name" {
  value = azurerm_resource_group.net.name
}

output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.hub.name
}

output "workloads_vnet_id" {
  value = azurerm_virtual_network.workloads.id
}

output "workloads_vnet_name" {
  value = azurerm_virtual_network.workloads.name
}

output "workloads_subnet_ids" {
  value = { for k, s in azurerm_subnet.workloads : k => s.id }
}