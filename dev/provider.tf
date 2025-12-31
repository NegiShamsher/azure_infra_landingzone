terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.57.0"
    }
  }
  # backend "azurerm"{

  #     resource_group_name  = "tfstate_rg"
  #     storage_account_name = "tfstate2026"
  #     container_name       = "tfstate"
  #     key                  = "dev.terraform.tfstate"
}




provider "azurerm" {
  features {}
  subscription_id = "f34f1734-8a3a-4c3a-9728-315b0a9f28a1"
}

