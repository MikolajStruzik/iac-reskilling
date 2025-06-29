variable "storage_account_name" {
  type        = string
  description = "Nazwa istniejącego Storage Account, w którym tworzymy tabelę"
}

variable "table_name" {
  type        = string
  description = "Nazwa tabeli, którą chcemy utworzyć"
  default     = "iacresources"
}
