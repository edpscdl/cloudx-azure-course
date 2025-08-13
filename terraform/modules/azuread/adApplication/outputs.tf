output "client_id" {
  value = azuread_application_registration.applicationRegistration.client_id
}

output "client_secret" {
  value = azuread_application_password.applicationPassword.value
}

output "application_registration_id" {
  value = azuread_application_registration.applicationRegistration.id
}