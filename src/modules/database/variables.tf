variable "resource_group_name" {
  type        = string
}

variable "storage_account_name" {
  type        = string
  description = "Nazwa istniejącego Storage Account, w którym tworzymy tabelę"
}

variable "table_name" {
  type        = string
  description = "Nazwa tabeli, którą chcemy utworzyć"
  default     = "resources"
}

variable "location" {
  type        = string
  default     = "westeurope"
}

variable "tags" {
  type        = map(string)
  description = "Tagi dla zasobów (opcjonalnie)"
  default = {
    Owner   = "mikolaj.struzik@atos.net"
    Project = "IaC Reskilling"
  }
}
