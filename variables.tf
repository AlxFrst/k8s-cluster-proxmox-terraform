variable "module_version" {
  description = "Version of the Terraform Alx module."
  type        = string
  default     = "1.0"
}

variable "proxmox_api_url" {
  description = "URL for the Proxmox API."
  type        = string
}

variable "proxmox_token_id" {
  description = "Token ID for Proxmox API authentication."
  type        = string
}

variable "proxmox_token_secret" {
  description = "Token secret for Proxmox API authentication."
  type        = string
}

variable "proxmox_node_name" {
  description = "Name of the Proxmox node to use for VM creation."
  type        = string
}

variable "proxmox_bridge_name" {
  description = "Name of the Proxmox bridge to use for VM creation."
  type        = string
}

variable "proxmox_tls_insecure" {
  description = "Flag to disable TLS verification for the Proxmox API. Set to true to disable verification."
  type        = bool
}

variable "metallb_ip_range" {
  description = "IP range for MetalLB."
  type        = string
}

variable "ip_address_start" {
  description = "Starting IP address for the VMs."
  type        = string
}

variable "ip_address_gateway" {
  description = "Gateway IP address for the VMs."
  type        = string
}

variable "ip_address_cidr" {
  description = "CIDR for the IP addresses."
  type        = string
  default     = "/24"
}

variable "ssh_private_key" {
  description = "Your SSH private key."
  type        = string
}

variable "ssh_public_key" {
  description = "Host for the SSH connection."
  type        = string
}



variable "vm_template_name" {
  description = "Name of the cloud-init template to use for VM creation."
  type        = string
}

variable "vm_name_prefix" {
  description = "Prefix for VM names."
  type        = string
}

variable "vm_user" {
  description = "Default user for the VMs."
  type        = string
}

variable "vm_password" {
  description = "Password for the VM user."
  type        = string
}

variable "vm_cloudinit_storage" {
  description = "Name of the storage for the cloud-init ISO."
  type        = string
}

variable "k8s_version" {
  description = "Version of Kubernetes to install."
  type        = string
  default     = "1.29"
}

variable "k8s_master_nodes" {
  description = "Number of Kubernetes master nodes. Does not include the main node."
  type        = number
}

variable "k8s_worker_nodes" {
  description = "Number of Kubernetes worker nodes."
  type        = number
}

variable "k8s_storage_nodes" {
  description = "Number of Kubernetes storage nodes."
  type        = number
}

variable "k8s_pod_network_cidr" {
  description = "CIDR for the Kubernetes pod network."
  type        = string
  default     = "10.244.0.0/16"
}

variable "load_balancer_cpu" {
    description = "Number of CPUs for the load balancer."
    type        = number
}

variable "load_balancer_socket" {
    description = "Number of sockets for the load balancer."
    type        = number
    default     = 1
}

variable "load_balancer_memory" {
    description = "Memory in MB for the load balancer."
    type        = number
}

variable "load_balancer_disk" {
    description = "Disk size in GB for the load balancer."
    type        = number
}

variable "load_balancer_ip" {
    description = "IP address for the load balancer."
    type        = number
}

variable "master_node_cpu" {
  description = "Number of CPUs for each master node."
  type        = number
}

variable "master_node_socket" {
  description = "Number of sockets for each master node."
  type        = number
  default     = 1
}

variable "master_node_memory" {
  description = "Memory in MB for each master node."
  type        = number
}

variable "master_node_disk" {
  description = "Disk size in GB for each master node."
  type        = number
}

variable "master_node_ip_start" {
  description = "Starting IP address for the master nodes."
  type        = number
}

variable "worker_node_cpu" {
  description = "Number of CPUs for each worker node."
  type        = number
}

variable "worker_node_socket" {
  description = "Number of sockets for each worker node."
  type        = number
  default     = 1
}

variable "worker_node_memory" {
  description = "Memory in MB for each worker node."
  type        = number
}

variable "worker_node_disk" {
  description = "Disk size in GB for each worker node."
  type        = number
}

variable "worker_node_ip_start" {
  description = "Starting IP address for the worker nodes."
  type        = number
}

variable "storage_node_cpu" {
  description = "Number of CPUs for each storage node."
  type        = number
}

variable "storage_node_socket" {
  description = "Number of sockets for each storage node."
  type        = number
  default     = 1
}

variable "storage_node_memory" {
  description = "Memory in MB for each storage node."
  type        = number
}

variable "storage_node_disk" {
  description = "Disk size in GB for each storage node."
  type        = number
}

variable "storage_node_ip_start" {
  description = "Starting IP address for the storage nodes."
  type        = number
}
