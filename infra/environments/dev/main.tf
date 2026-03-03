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

  # Network Platform Resource Group
  rg_platform_network = "${var.name_prefix}-rg-platform-network-${var.env}"

  # Hub Virtual Network
  hub_vnet_name       = "vnet-${var.name_prefix}-hub-${var.env}"
  hub_address_space   = ["10.0.0.0/16"]

  # Workloads (spoke) Virtual Network
  workloads_vnet_name     = "vnet-${var.name_prefix}-workloads-${var.env}"
  workloads_address_space = ["10.1.0.0/16"]
  workloads_subnets = {
    "snet-appint-${var.env}" = { address_prefixes = ["10.1.1.0/24"] } 
    "snet-pe-${var.env}"     = { address_prefixes = ["10.1.2.0/24"] } 
  }

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

module "platform_network" {
  source = "../../modules/platform_network"

  location            = var.location
  resource_group_name = local.rg_platform_network

  hub_vnet_name      = local.hub_vnet_name
  hub_address_space  = local.hub_address_space

  workloads_vnet_name      = local.workloads_vnet_name
  workloads_address_space  = local.workloads_address_space
  workloads_subnets        = local.workloads_subnets

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

output "network_rg" {
  value = module.platform_network.resource_group_name
}

output "workloads_subnet_ids" {
  value = module.platform_network.workloads_subnet_ids
}
