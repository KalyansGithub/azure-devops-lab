# 1. Hub Virtual Network
resource "azurerm_virtual_network" "hub_vnet" {
  name                = "vnet-hub-eastus-001"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    Environment = "Dev"
    Role        = "Network-Hub"
  }
}

# Hub Management Subnet (e.g., for Azure Bastion or VPN)
resource "azurerm_subnet" "hub_mgmt_subnet" {
  name                 = "snet-hub-mgmt"
  resource_group_name  = azurerm_resource_group.lab_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}