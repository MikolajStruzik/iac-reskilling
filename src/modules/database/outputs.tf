output "table_name" {
  description = "Name of the Azure Table Storage"
  value = azurerm_storage_table.resource_table.name
}