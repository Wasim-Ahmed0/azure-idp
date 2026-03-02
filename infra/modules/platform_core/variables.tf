variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for platform core"
}

variable "acr_name" {
  type        = string
  description = "Azure Container Registry name"
}

variable "log_analytics_name" {
  type        = string
  description = "Log Analytics workspace name"
}

variable "key_vault_name" {
  type        = string
  description = "Key Vault name"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to resources"
}