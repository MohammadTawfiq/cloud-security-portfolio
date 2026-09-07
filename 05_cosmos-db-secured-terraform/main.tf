resource "azurerm_resource_group" "rg" {
  name     = "rg-cosmosdb-project5"
  location = "Central India"
}
resource "azurerm_cosmosdb_account" "cosmos" {
  name                = "cosmos-mtawfiq-p5"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }

  public_network_access_enabled = false  # secured from the start, not patched in later
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-cosmosdb-project5"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-private-endpoints"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_private_endpoint" "cosmos_pe" {
  name                = "pe-cosmos-project5"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "psc-cosmos-project5"
    private_connection_resource_id = azurerm_cosmosdb_account.cosmos.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_cosmosdb_sql_role_assignment" "reader_assignment" {
  resource_group_name = azurerm_resource_group.rg.name
  account_name         = azurerm_cosmosdb_account.cosmos.name
  role_definition_id   = "${azurerm_cosmosdb_account.cosmos.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000001"
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_cosmosdb_account.cosmos.id
}