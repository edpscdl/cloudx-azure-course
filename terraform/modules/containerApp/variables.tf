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

variable "revision_mode" {
  type    = string
  default = "Single"
}

variable "application_insights_connection_string" {
  type = string
}

variable "container_registry_login_server" {
  type = string
}

variable "container_registry_admin_username" {
  type = string
}

variable "container_registry_admin_password" {
  type = string
}