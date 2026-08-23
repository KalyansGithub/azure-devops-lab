resource "azurerm_resource_group" "lab_rg" {
  name     = "rg-enterprise-lab-dev"
  location = "eastus2"
  tags = {
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}