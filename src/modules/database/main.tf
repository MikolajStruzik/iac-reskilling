# resource "azurerm_storage_account" "db_sa" {
#   #name                     = "iacsadb${random_string.suffix.result}"
#   #name                     = "iacreskillingweb01"
#   name                     = var.storage_account_name
#   resource_group_name      = var.resource_group_name
#   location                 = var.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   tags                     = var.tags
# }

// Korzystamy z już istniejącego Storage Account (dostarczyłeś go root/main.tf)
data "azurerm_storage_account" "db_sa" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

// Tworzymy tylko tabelę w tym Storage Account
resource "azurerm_storage_table" "db_table" {
  name                 = var.table_name
  storage_account_name = data.azurerm_storage_account.db_sa.name
}

