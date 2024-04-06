resource "proxmox_vm_qemu" "k8s_loadbalancer" {
  count                   = 1
  name                    = "${var.vm_name_prefix}-loadbalancer"
  target_node             = var.proxmox_node_name
  clone                   = var.vm_template_name
  agent                   = 1
  cloudinit_cdrom_storage = var.vm_cloudinit_storage
  os_type                 = "cloud-init"
  cores                   = var.load_balancer_cpu
  sockets                 = var.load_balancer_socket
  cpu                     = "host"
  memory                  = var.load_balancer_memory
  scsihw                  = "virtio-scsi-pci"
  ipconfig0               = "ip=${var.ip_address_start}.${var.load_balancer_ip}/${var.ip_address_cidr},gw=${var.ip_address_gateway}"
  ciuser                  = var.vm_user
  cipassword              = var.vm_password
  sshkeys                 = var.ssh_public_key
  qemu_os                 = "l26"
  disks {
    scsi {
      scsi0 {
        disk {
          size    = var.load_balancer_disk
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
    "until sudo apt-get install haproxy -y; do echo 'apt-get install haproxy failed, retrying...'; sleep 5; done",
    "sudo bash -c 'echo \"frontend fe-apiserver\" >> /etc/haproxy/haproxy.cfg'",
    "sudo bash -c 'echo \"    bind 0.0.0.0:6443\" >> /etc/haproxy/haproxy.cfg'",
    "sudo bash -c 'echo \"    mode tcp\" >> /etc/haproxy/haproxy.cfg'",
    "sudo bash -c 'echo \"    option tcplog\" >> /etc/haproxy/haproxy.cfg'",
    "sudo bash -c 'echo \"    default_backend be-apiserver\" >> /etc/haproxy/haproxy.cfg'",
    "sudo bash -c 'echo \"backend be-apiserver\" >> /etc/haproxy/haproxy.cfg'",
    "sudo bash -c 'echo \"    mode tcp\" >> /etc/haproxy/haproxy.cfg'",
    "sudo bash -c 'echo \"    option tcplog\" >> /etc/haproxy/haproxy.cfg'",
    "sudo bash -c 'echo \"    option tcp-check\" >> /etc/haproxy/haproxy.cfg'",
    "sudo bash -c 'echo \"    balance roundrobin\" >> /etc/haproxy/haproxy.cfg'",
    "sudo bash -c 'echo \"    default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100\" >> /etc/haproxy/haproxy.cfg'",
    "sudo bash -c 'echo \"    server ${var.vm_name_prefix}-master-1 ${var.ip_address_start}.${var.master_node_ip_start}:6443 check\" >> /etc/haproxy/haproxy.cfg'",
    "sudo systemctl enable haproxy",
    "sudo systemctl restart haproxy",

    # Create directories for the apps and tools
    "sudo mkdir apps",
    "sudo mkdir tools",
    "sudo mkdir tools/cluster",
    "sudo mkdir .kube",
    "sudo chown -R ${var.vm_user}:${var.vm_user} .kube",
    "sudo chown -R ${var.vm_user}:${var.vm_user} apps",
    "sudo chown -R ${var.vm_user}:${var.vm_user} tools",

    "sudo mkdir .kube",
    "sudo chown -R ${var.vm_user}:${var.vm_user} .kube",

    "until sudo snap install kubectl --classic; do echo 'snap install kubectl failed, retrying...'; sleep 5; done",

    # Add calico
    # Add metallb
  ]
}
}
