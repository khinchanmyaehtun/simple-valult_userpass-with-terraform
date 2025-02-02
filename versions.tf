terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.5.0"
    }
  }
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = var.dev_server1_token
}