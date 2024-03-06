terraform {
  required_version = ">= 1.5.0"

  required_providers {
    nws = {
      source  = "tfr.nws.neurodyne.pro/nws/nws" # NWS Terraform registry
      version = "0.0.1"
    }
  }
}

// read token from file
locals {
  creds = yamldecode(file("${path.module}/secrets.yml"))
}

// Init provider
provider "nws" {
  endpoint = "api.nws.neurodyne.pro:443"
  region   = "ru-msk-0a"
  token    = local.creds.token
}

// create a resource
resource "nws_demo_friends" "friends" {
  name = "Ivan"
  friends = [
    {
      name = "Nastya"
      sex  = "F"
      age  = 24
    },
    {
      name = "Semen"
      sex  = "M"
      age  = 34
    }
  ]
}

