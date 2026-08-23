resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-dev-eastus-001"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  dns_prefix          = "aks-dev-lab"

  # Required block for azurerm v4.x+
  node_provisioning_profile {
    mode = "Manual"
  }

  default_node_pool {
    name            = "systempool"
    node_count      = 1
    vm_size         = "Standard_D2s_v6" # Cost-effective burstable VM for dev
    vnet_subnet_id  = azurerm_subnet.spoke_app_subnet.id
    os_disk_size_gb = 30
  }
  # Use the User-Assigned Managed Identity created in Phase 2
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  # Azure CNI Networking attached to Spoke App Subnet  
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
  tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}
/*
# 3. Attach ACR to AKS (AcrPull Role Assignment)
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}*/