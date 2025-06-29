output "table_name" {
  description = "Nazwa utworzonej tabeli"
  value       = azurerm_storage_table.db_table.name
}
