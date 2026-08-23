# NSG for Spoke Ingress Subnet (Allows HTTP/HTTPS traffic from Internet)

resource "azurerm_network_security_group" "ingress_nsg" {
  name                = "nsg-spoke-ingress"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name

  security_rule {
    name                       = "Allow-HTTP-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS-Inbound"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# NSG for Private Application Subnet (Restricts Inbound Traffic only to the Ingress Subnet)
resource "azurerm_network_security_group" "app_nsg" {
  name                = "nsg-spoke-app"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name

  security_rule {
    name                       = "Allow-IngressSubnet-Only"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.1.1.0/24" # Ingress Subnet CIDR
    destination_address_prefix = "*"
  }
}

# Associate NSGs with Subnets
resource "azurerm_subnet_network_security_group_association" "ingress_nsg_assoc" {
  subnet_id                 = azurerm_subnet.spoke_ingress_subnet.id
  network_security_group_id = azurerm_network_security_group.ingress_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "app_nsg_assoc" {
  subnet_id                 = azurerm_subnet.spoke_app_subnet.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}