# User-Assigned Managed Identity (Avoids hardcoded API keys/passwords)
resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "id-aks-dev-eastus"
  resource_group_name = azurerm_resource_group.lab_rg.name
  location            = azurerm_resource_group.lab_rg.location
}

# Fetch tenant details automatically
data "azurerm_client_config" "current" {}

# Random Suffix Generator for Globally Unique Key Vault Name
resource "random_string" "kv_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Azure Key Vault Deployment
resource "azurerm_key_vault" "kv" {
  name                        = "kv-dev-lab-${random_string.kv_suffix.result}"
  location                    = azurerm_resource_group.lab_rg.location
  resource_group_name         = azurerm_resource_group.lab_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  rbac_authorization_enabled  = false

  # Access Policy for Current Terraform Execution Identity
  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = data.azurerm_client_config.current.object_id
    secret_permissions = ["Get", "List", "Set", "Delete", "Purge"]
  }
  # Access Policy for Application Managed Identity
  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = azurerm_user_assigned_identity.aks_identity.principal_id
    secret_permissions = ["Get", "List"]
  }
}

# Sample Secret Entry
resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-admin-password"
  value        = "P@ssw0rd2026!Secure"
  key_vault_id = azurerm_key_vault.kv.id
}