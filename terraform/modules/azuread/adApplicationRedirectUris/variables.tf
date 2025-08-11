variable "application_registration_id" {
  type = string
}

variable "type" {
  type = string
  default = "Web"
}

variable "redirect_uris" {
  type = list(string)
}