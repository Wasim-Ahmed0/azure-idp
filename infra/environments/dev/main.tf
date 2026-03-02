terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.16.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "loc" {
  type    = string
  default = "uks"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "name_prefix" {
  description = "Short prefix used for naming"
  type        = string
  default     = "azidp"
}

locals {
  # Azure Container Registry
  acr_name = "${var.name_prefix}${var.env}${var.loc}acr"

  # Key Vault
  kv_name = "${var.name_prefix}${var.env}${var.loc}kv"

  # Log Analytics Workspace
  law_name = "${var.name_prefix}${var.env}-${var.loc}-law"

  # Core Platform Resource Group
  rg_platform_core = "${var.name_prefix}-rg-platform-core-${var.env}"

  tags = {
    project = "azure-idp"
    env     = var.env
  }
}

module "platform_core" {
  source = "../../modules/platform_core"

  location            = var.location
  resource_group_name = local.rg_platform_core

  acr_name           = local.acr_name
  log_analytics_name = local.law_name
  key_vault_name     = local.kv_name

  tags = local.tags
}

output "platform_core_rg" {
  value = module.platform_core.resource_group_name
}

output "acr_login_server" {
  value = module.platform_core.acr_login_server
}

output "key_vault_name" {
  value = module.platform_core.key_vault_name
}
