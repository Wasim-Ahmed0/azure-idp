variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for networking resources"
}

variable "hub_vnet_name" {
  type        = string
  description = "Hub VNet name"
}

variable "hub_address_space" {
  type        = list(string)
  description = "Hub VNet address space"
}

variable "workloads_vnet_name" {
  type        = string
  description = "Workloads (spoke) VNet name"
}

variable "workloads_address_space" {
  type        = list(string)
  description = "Workloads (spoke) VNet address space"
}

variable "workloads_subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
  description = "Map of subnet definitions for workloads VNet"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to resources"
  default     = {}
}