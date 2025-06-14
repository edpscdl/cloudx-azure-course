variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "application_type" {
  type    = string
  default = "java"
}

variable "workspace_id" {
  type = string
}
