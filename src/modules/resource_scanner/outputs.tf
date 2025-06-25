output "function_url" {
  description = "Public endpoint of scanner"
  value       = azurerm_function_app.scanner.default_hostname
}