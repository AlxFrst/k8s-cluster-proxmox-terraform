resource "proxmox_vm_qemu" "k8s_storage" {
  depends_on              = [proxmox_vm_qemu.k8s_master_main]
  count                   = var.k8s_storage_nodes
  name                    = "${var.vm_name_prefix}-storage-${count.index + 1}"
  target_node             = var.proxmox_node_name
  clone                   = var.vm_template_name
  agent                   = 1
  cloudinit_cdrom_storage = var.vm_cloudinit_storage
  os_type                 = "cloud-init"
  cores                   = var.storage_node_cpu
  sockets                 = var.storage_node_socket
  cpu                     = "host"
  memory                  = var.storage_node_memory
  scsihw                  = "virtio-scsi-pci"
  ipconfig0               = "ip=${var.ip_address_start}.${var.storage_node_ip_start + count.index}/${var.ip_address_cidr},gw=${var.ip_address_gateway}"
  ciuser                  = var.vm_user
  cipassword              = var.vm_password
  sshkeys                 = var.ssh_public_key
  qemu_os                 = "l26"
  disks {
    scsi {
      scsi0 {
        disk {
          size    = var.storage_node_disk
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
      "until sudo apt-get install -y nfs-kernel-server; do echo 'nfs-kernel-server installation failed, retrying...'; sleep 5; done",
      "sudo mkdir -p /mnt/nfs-share",
      "sudo chown nobody:nogroup /mnt/nfs-share",
      "sudo chmod 777 /mnt/nfs-share",
      "echo '/mnt/nfs-share ${var.ip_address_start}.0/24(rw,sync,no_subtree_check,no_root_squash)' | sudo tee -a /etc/exports",
      "sudo systemctl restart nfs-kernel-server",
      "sudo systemctl enable nfs-kernel-server",
    ]
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = var.ssh_private_key
      host        = "${var.ip_address_start}.${var.master_node_ip_start}"
    }
    inline = [
        "if [ ! -f /usr/local/bin/helm ]; then curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3; chmod 700 get_helm.sh; ./get_helm.sh; fi",
        "helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner",
        "helm repo update",
        "helm install nfs-subdir-external-provisioner-storage-${count.index + 1} nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --set nfs.server=${self.ssh_host} --set nfs.path=/mnt/nfs-share --set storageClass.name=nfs-client-storage-${count.index + 1} --set storageClass.archiveOnDelete=false --set storageClass.onDelete=delete",
    ]
  }
  // TODO: On destroy, remove the storageClass and the provisioner from the cluster
}
