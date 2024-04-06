resource "proxmox_vm_qemu" "k8s_master_main" {
  depends_on              = [proxmox_vm_qemu.k8s_loadbalancer]
  count                   = 1
  name                    = "${var.vm_name_prefix}-master-1"
  target_node             = var.proxmox_node_name
  clone                   = var.vm_template_name
  agent                   = 1
  cloudinit_cdrom_storage = var.vm_cloudinit_storage
  os_type                 = "cloud-init"
  cores                   = var.master_node_cpu
  sockets                 = var.master_node_socket
  cpu                     = "host"
  memory                  = var.master_node_memory
  scsihw                  = "virtio-scsi-pci"
  ipconfig0               = "ip=${var.ip_address_start}.${var.master_node_ip_start}/${var.ip_address_cidr},gw=${var.ip_address_gateway}"
  ciuser                  = var.vm_user
  cipassword              = var.vm_password
  sshkeys                 = var.ssh_public_key
  qemu_os                 = "l26"
  disks {
    scsi {
      scsi0 {
        disk {
          size    = var.master_node_disk
          storage = var.vm_cloudinit_storage
        }
      }
    }
  }
  network {
    model  = "virtio"
    bridge = var.proxmox_bridge_name
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = var.ssh_private_key
      host        = self.ssh_host
    }
    inline = [
      "until sudo apt-get update; do echo 'apt-get update failed, retrying...'; sleep 5; done",
      "sudo swapoff -a",
      "until sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common nfs-common; do echo 'apt-get install failed, retrying...'; sleep 5; done",
      "sudo bash -c 'echo \"deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /\" > /etc/apt/sources.list.d/kubernetes.list'",
      "sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
      "until sudo apt-get update -y; do echo 'apt-get update failed, retrying...'; sleep 5; done",
      "until sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y; do echo 'apt-get install failed, retrying...'; sleep 5; done",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "until sudo apt-get update -y; do echo 'apt-get update failed, retrying...'; sleep 5; done",
      "until sudo apt-get install docker-ce docker-ce-cli containerd.io -y; do echo 'apt-get install docker failed, retrying...'; sleep 5; done",
      "until sudo apt-get install -y containerd.io; do echo 'apt-get install containerd.io failed, retrying...'; sleep 5; done",
      "until sudo apt-get install -y kubelet kubeadm kubectl; do echo 'apt-get install kubelet kubeadm kubectl failed, retrying...'; sleep 5; done",
      "sudo apt-mark hold kubelet kubeadm kubectl",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo modprobe br_netfilter",
      "sudo rm /etc/containerd/config.toml",
      "sudo systemctl restart containerd",
      "sudo bash -c 'echo \"1\" > /proc/sys/net/ipv4/ip_forward'",
      "sudo kubeadm init --control-plane-endpoint \"${var.ip_address_start}.${var.load_balancer_ip}:6443\" --upload-certs --pod-network-cidr=10.244.0.0/16 | tee /tmp/kubeadm-init.log",
      "mkdir -p $HOME/.kube",
      "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
      "sudo chown $(id -u):$(id -g) $HOME/.kube/config",
      "sudo grep -A 1 'kubeadm join' /tmp/kubeadm-init.log | sudo tail -n 1 > /tmp/kubeadm-join-command.sh",


      "until sudo apt install python3 -y; do echo 'apt-get install python3 failed, retrying...'; sleep 5; done",
      "until sudo apt install python3-pip -y; do echo 'apt-get install python3-pip failed, retrying...'; sleep 5; done",
    ]
  }
}
