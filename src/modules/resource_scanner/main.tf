data "azurerm_client_config" "current" {}

resource "azurerm_service_plan" "plan" {
  name                = "${var.name_prefix}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "scanner" {
  name                       = "${var.name_prefix}-scanner-func"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.plan.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_key

  zip_deploy_file = "${path.module}/function_app.zip"

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack { python_version = "3.9" }

    cors {
      allowed_origins     = ["https://portal.azure.com"]
      support_credentials = false
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME    = "python"
    FUNCTIONS_EXTENSION_VERSION = "~4"
    AzureWebJobsStorage         = var.storage_account_connection_string
    TAG_OWNER                   = var.tag_owner
    TAG_PROJECT                 = var.tag_project
    TABLE_NAME                  = var.table_name
    BLOB_CONTAINER              = var.blob_container
    SUBSCRIPTION_ID             = var.subscription_id
  }

  tags = {
    Owner   = var.tag_owner
    Project = var.tag_project
  }
}
