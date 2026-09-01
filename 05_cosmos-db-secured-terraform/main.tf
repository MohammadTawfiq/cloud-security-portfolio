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