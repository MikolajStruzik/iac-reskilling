output "function_url" {
  description = "Publiczny FQDN Function App"
  value       = azurerm_linux_function_app.scanner.default_hostname
}
