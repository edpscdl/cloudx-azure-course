terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "=3.5.0"
    }
  }
}

provider "azuread" {
  tenant_id = var.tenant_id
}
