// Korzystamy z istniejącego Storage Account przekazanego z root
resource "azurerm_storage_table" "db_table" {
  name                 = var.table_name
  storage_account_name = var.storage_account_name   # <-- tylko nazwa
}
