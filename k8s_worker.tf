resource "proxmox_vm_qemu" "k8s_worker" {
  depends_on              = [proxmox_vm_qemu.k8s_master_main]
  count                   = var.k8s_worker_nodes
  name                    = "${var.vm_name_prefix}-worker-${count.index + 1}"
  target_node             = var.proxmox_node_name
  clone                   = var.vm_template_name
  agent                   = 1
  cloudinit_cdrom_storage = var.vm_cloudinit_storage
  os_type                 = "cloud-init"
  cores                   = var.worker_node_cpu
  sockets                 = var.worker_node_socket
  cpu                     = "host"
  memory                  = var.worker_node_memory
  scsihw                  = "virtio-scsi-pci"
  ipconfig0               = "ip=${var.ip_address_start}.${var.worker_node_ip_start + count.index}/${var.ip_address_cidr},gw=${var.ip_address_gateway}"
  ciuser                  = var.vm_user
  cipassword              = var.vm_password
  sshkeys                 = var.ssh_public_key
  qemu_os                 = "l26"
  disks {
    scsi {
      scsi0 {
        disk {
          size    = var.worker_node_disk
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

      "sudo bash -c 'echo -e \"${var.ssh_private_key}\" > /home/${var.vm_user}/.ssh/id_rsa'",
      "sudo chmod 600 /home/${var.vm_user}/.ssh/id_rsa",
      "sudo chown ${var.vm_user}:${var.vm_user} /home/${var.vm_user}/.ssh/id_rsa",
      "eval $(ssh-agent -s)",
      "ssh-add /home/${var.vm_user}/.ssh/id_rsa",

      // Join the master nodes
      "scp -o StrictHostKeyChecking=no ${var.vm_user}@${var.ip_address_start}.${var.load_balancer_ip}:/home/${var.vm_user}/tools/cluster/workerJoin.sh /tmp/workerJoin.sh",
      "sudo chmod +x /tmp/workerJoin.sh",
      "sudo bash /tmp/workerJoin.sh"
    ]
  }
}
