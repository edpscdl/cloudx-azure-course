variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "container_app_environment_id" {
  type = string
}

variable "application_name" {
  type = string
}

variable "enviroment_variables" {
  type    = map(string)
  default = {}
}

variable "key_vault_id" {
  type = string
}

variable "application_insights_connection_string_secret_name" {
  type = string
}

variable "container_registry_login_server_secret_name" {
  type = string
}

variable "user_assigned_identity_id" {
  type = string
}

variable "postgresql_server_id" {
  type    = string
  default = ""
}