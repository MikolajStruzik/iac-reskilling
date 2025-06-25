resource "azurerm_storage_table" "resource_table" {
  name = var.table_name
  storage_account_name = var.storage_account_name
}

# Insert a row describing the resource
resource "azurerm_storage_table_entity" "resource" {
  storage_account_name = var.storage_account_name
  table_name           = azurerm_storage_table.resource_table.name

  # Use the provided resource_id as part of the primary key
  partition_key = "resources"
  row_key       = var.resource_id

  entity = jsonencode({
    resource_id = var.resource_id
  })
}

