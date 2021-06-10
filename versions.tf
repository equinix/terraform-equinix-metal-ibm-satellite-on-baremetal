terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
    metal = {
      source = "equinix/metal"
      version = "2.1.0" 
    }
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.23.2"
    }
    random = {
      source = "hashicorp/random"
    }
    template = {
      source = "hashicorp/template"
    }
    tls = {
      source = "hashicorp/tls"
    }
    local = {
      source = "hashicorp/local"
    }
  }
  required_version = ">= 0.13"
}
