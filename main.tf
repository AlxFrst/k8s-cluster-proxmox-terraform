terraform {
  backend "s3" {
    region     = "main"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true # Important pour MinIO
  }
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
  required_version = "1.6.4"
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure     = var.proxmox_tls_insecure
}
