terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-dev"
    storage_account_name = "tfstate210547144"
    container_name       = "tfstate"
    key                  = "dev.tfstate"
  }
}