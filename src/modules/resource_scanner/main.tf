resource "azurerm_function_app" "scanner" {
  name                       = "${var.name_prefix}-scanner-func"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_key
  app_service_plan_id        = azurerm_app_service_plan.plan.id
  version                    = "~4"  # wersja Functions v4

      app_settings = {
          FUNCTIONS_WORKER_RUNTIME    = "python"
          AzureWebJobsStorage         = azurerm_storage_account.sa.primary_connection_string
          TAG_OWNER                   = var.tag_owner
          TAG_PROJECT                 = var.tag_project
          TABLE_NAME                  = var.table_name
          BLOB_CONTAINER              = var.blob_container
          SUBSCRIPTION_ID             = var.subscription_id
      }
}

resource "azurerm_app_service_plan" "plan" {
  name                = "${var.name_prefix}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "FunctionApp"
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.name_prefix}scanner00"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "code" {
  name                  = "function-code"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

# Wyślij kod funkcji do Azure, np. z Azure CLI:
# az storage blob upload-batch --account-name ... --destination function-code --source modules/resource_scanner/function_app
