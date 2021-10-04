terraform {
  required_providers {
    sshcommand = {
      source  = "invidian/sshcommand"
      version = "0.2.2"
    }
    sshclient = {
      source  = "luma-planet/sshclient"
      version = "1.0.1"
    }
    
  }
}


provider "vsphere" {
    user           = var.vsphere_env.user
    password       = var.vsphere_env.password
    vsphere_server = var.vsphere_env.server
    # If you have a self-signed cert
    allow_unverified_ssl = true
}

# Deploy Kickstart VM (Based on VM-DEMO)
resource "random_password" "kickoffvm_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

### Put all data into file step1 under tkg directory (this file will be used by the other tkg module for further operations)
