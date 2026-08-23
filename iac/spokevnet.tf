resource "azurerm_virtual_network" "spoke_vnet" {
  name                = "vnet-spoke-eastus-001"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  address_space       = ["10.1.0.0/16"]

  tags = {
    Environment = "Dev"
    Role        = "Network-Spoke"
  }
}

# Spoke Ingress/Public Subnet (For Load Balancers / Ingress)
resource "azurerm_subnet" "spoke_ingress_subnet" {
  name                 = "snet-spoke-ingress"
  resource_group_name  = azurerm_resource_group.lab_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Spoke Private Application Subnet (For AKS Nodes & Workloads)
resource "azurerm_subnet" "spoke_app_subnet" {
  name                 = "snet-spoke-app"
  resource_group_name  = azurerm_resource_group.lab_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = ["10.1.2.0/24"]
}