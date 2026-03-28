terraform {
  backend "kubernetes" {
    namespace     = "vault"
    secret_suffix = "vault-terraform-foundational"
  }
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "5.8.0"
    }
  }
}

provider "vault" {}