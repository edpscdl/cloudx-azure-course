variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "account_replication_type" {
  type    = string
  default = "LRS"
}

variable "account_kind" {
  type    = string
  default = "StorageV2"
}

variable "container_name" {
  type    = string
  default = "archive"
}

variable "container_access_type" {
  type    = string
  default = "private"
}

variable "key_vault_id" {
  type = string
}