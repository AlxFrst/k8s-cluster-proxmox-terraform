terraform {
  backend "s3" {
    endpoint   = var.backend_endpoint # Utilisez l'adresse IP ou le nom de domaine de votre instance MinIO
    bucket     = var.backend_bucket
    key        = var.backend_key
    region     = "main"
    access_key = var.backend_access_key
    secret_key = var.backend_secret_key

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
