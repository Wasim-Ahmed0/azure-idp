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

variable "env" {
  type    = string
  default = "dev"
}

resource "azurerm_resource_group" "env" {
  name     = "rg-idp-${var.env}"
  location = var.location

  tags = {
    project = "azure-idp"
    env     = var.env
  }
}