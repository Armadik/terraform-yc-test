variable "folder_id" {
  description = "(optional)"
  type        = string
  default     = null
}

variable "name" {
  description = "(optional)"
  type        = string
  default     = null
}

variable subnet_id {
  description = "Subnet"
}

variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-b"
}

variable "network_id" {
  description = "Network"
}

variable "node_service_account_id" {
  description = "(required)"
}

variable "service_account_id" {
  description = "(required)"
}

variable "kms-key" {
  description = "(required)"
}


