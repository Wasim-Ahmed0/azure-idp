# Network resource group
resource "azurerm_resource_group" "net" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Hub VNet
resource "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  location            = azurerm_resource_group.net.location
  resource_group_name = azurerm_resource_group.net.name
  address_space       = var.hub_address_space
  tags                = var.tags
}

# Spoke VNet
resource "azurerm_virtual_network" "workloads" {
  name                = var.workloads_vnet_name
  location            = azurerm_resource_group.net.location
  resource_group_name = azurerm_resource_group.net.name
  address_space       = var.workloads_address_space
  tags                = var.tags
}

# Create subnets in workloads VNet
resource "azurerm_subnet" "workloads" {
  for_each             = var.workloads_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.net.name
  virtual_network_name = azurerm_virtual_network.workloads.name
  address_prefixes     = each.value.address_prefixes
}

# Peering hub <--> workloads (spoke)
resource "azurerm_virtual_network_peering" "hub_to_workloads" {
  name                      = "peer-${var.hub_vnet_name}-to-${var.workloads_vnet_name}"
  resource_group_name       = azurerm_resource_group.net.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.workloads.id

  allow_virtual_network_access = true
}

# Peering workloads (spoke) <--> hub
resource "azurerm_virtual_network_peering" "workloads_to_hub" {
  name                      = "peer-${var.workloads_vnet_name}-to-${var.hub_vnet_name}"
  resource_group_name       = azurerm_resource_group.net.name
  virtual_network_name      = azurerm_virtual_network.workloads.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
}