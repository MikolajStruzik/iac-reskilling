# output "function_url" {
#   description = "Public endpoint of scanner"
#   value       = azurerm_function_app.scanner.default_hostname
# }

output "function_url" {
  description = "Publiczny FQDN Twojej Function App"
  value       = azurerm_linux_function_app.scanner.default_hostname
}