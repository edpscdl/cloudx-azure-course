variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "application_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "servicebus_queue_name" {
  type = string
}

variable "service_plan_id" {
  type = string
}

variable "user_assigned_identity_id" {
  type = string
}

variable "secret_name_storage_account_access_key" {
  type = string
}

variable "secret_name_storage_account_connection_string" {
  type = string
}

variable "secret_name_application_insights_connection_string" {
  type = string
}

variable "secret_name_container_registry_login_server" {
  type = string
}

variable "secret_name_container_registry_admin_username" {
  type = string
}

variable "secret_name_container_registry_admin_password" {
  type = string
}

variable "secret_name_servicebus_queue_connection_string" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "enviroment_variables" {
  type    = map(string)
  default = {}
}