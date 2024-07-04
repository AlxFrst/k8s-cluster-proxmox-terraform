# Proxmox variables
proxmox_node_name="rocket" # The name of the Proxmox node
proxmox_bridge_name="vmbr0" # The name of the Proxmox bridge
proxmox_tls_insecure=true # Whether to ignore TLS errors

# Network variables
ip_address_start="192.168.1" # The first three octets of the IP address
ip_address_gateway="192.168.1.1" # The gateway IP address
ip_address_cidr="24" # The CIDR notation of the IP address

# Virtual machine variables
vm_template_name="ubuntu-2004-cloudinit" #Please use a cloud-init template
vm_name_prefix="kube" # The prefix of the virtual machine name
vm_user="ubuntu" # The user of the virtual machine
vm_password="ubuntu" # The password of the virtual machine
vm_cloudinit_storage="local-lvm" # The storage where the cloud-init configuration will be stored

# Cluster configuration
k8s_version= "1.28" # The version of Kubernetes
k8s_master_nodes= 2 # Number of master nodes (the main node is always the first one and not included in this number, so if you want 3 master nodes, you should put 2 here)
k8s_worker_nodes= 3 # Number of worker nodes (recommended 3 or more for production environments)
k8s_storage_nodes= 1 # Number of storage nodes (if you don't want storage nodes, put 0 here)
k8s_pod_network_cidr= "10.244.0.0" # The CIDR notation of the pod network
metallb_ip_range= "192.168.1.160-192.168.1.180" # The IP range for MetalLB

# Load balancer configuration
load_balancer_cpu= 2 # Number of CPUs
load_balancer_socket= 1 # Number of sockets
load_balancer_memory= 2048 # Memory in MB
load_balancer_disk= 30 # Disk size in GB
load_balancer_ip= 121 # IP address of the load balancer (this will be 192.168.1.121/24)

# Master node configuration
master_node_cpu= 2# Number of CPUs
master_node_socket= 1 # Number of sockets
master_node_memory= 4096# Memory in MB
master_node_disk= 20 # Disk size in GB
master_node_ip_start= 122 # IP address of the first master node (this will be 192.168.1.122/24, the next one will be 192.168.1.123/24, and so on)

# Worker node configuration
worker_node_cpu= 4 # Number of CPUs
worker_node_socket= 1 # Number of sockets
worker_node_memory= 8192 # Memory in MB
worker_node_disk= 20 # Disk size in GB
worker_node_ip_start= 130 # IP address of the first worker node (this will be 192.168.1.130/24, the next one will be 192.168.1.131/24, and so on)

# Storage node configuration
storage_node_cpu= 2 # Number of CPUs
storage_node_socket= 1 # Number of sockets
storage_node_memory= 2048 # Memory in MB
storage_node_disk= 100 # Disk size in GB
storage_node_ip_start= 140 # IP address of the first storage node (this will be 192.168.1.140/24, the next one will be 192.168.1.131/24, and so on)