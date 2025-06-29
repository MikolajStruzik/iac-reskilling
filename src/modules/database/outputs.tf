output "table_name" {
  description = "Nazwa utworzonej tabeli w Storage Account"
  value       = azurerm_storage_table.db_table.name
}

output "storage_account_name" {
  description = "Storage Account użyty do przechowywania tabeli"
  value       = data.azurerm_storage_account.db_sa.name
}