// 1️⃣ Service Plan (Linux, funkcje Consumption)
resource "azurerm_service_plan" "plan" {
  name                = "${var.name_prefix}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "Y1"
}

// 2️⃣ Linux Function App
resource "azurerm_linux_function_app" "scanner" {
  name                       = "${var.name_prefix}-scanner-func"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.plan.id

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_key

  # Jeśli potrzebujesz Managed Identity:
  identity {
    type = "SystemAssigned"
  }

  site_config {
    # określamy jedynie wersję Pythona
    application_stack {
      python_version = "3.9"
    }
    # opcjonalnie, można dodać linux_fx_version,
    # ale przy application_stack nie jest konieczne
    linux_fx_version = "PYTHON|3.9"
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME          = "python"
    AzureWebJobsStorage               = var.storage_account_connection_string
    STORAGE_ACCOUNT_NAME              = var.storage_account_name
    STORAGE_ACCOUNT_KEY               = var.storage_account_key
    TABLE_NAME                        = var.table_name
    BLOB_CONTAINER                    = var.blob_container
    SUBSCRIPTION_ID                   = var.subscription_id
    # ... inne zmienne środowiskowe
  }

  tags = {
    Owner   = var.tag_owner
    Project = var.tag_project
  }
}