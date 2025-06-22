resource "random_password" "reverse-proxy-password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "proxmox_vm_qemu" "reverse-proxy" {
  count = 1
  name = "reverse-proxy"
  target_node = "node1"
  clone = "vmtemp"
  memory = 2048
  agent = 1

  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  
  cpu {
    cores = 2
    sockets = 1
  }

  disks {
        ide {
            ide2 {
                cloudinit {
                    storage = "local-lvm"
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                    size            = 32
                    cache           = "writeback"
                    storage         = "local-lvm"
                    #storage_type    = "rbd"
                    #iothread        = true
                    #discard         = true
                    replicate       = true
                }
            }
        }
    }

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr0"
  }

  boot = "order=scsi0"

  ipconfig0 = "ip=192.168.178.112/24,gw=192.168.178.1"
  os_type = "cloud-init"
  vmid = "9111"

  ciuser = var.ssh_user
  sshkeys = var.ssh_pub_key
  cipassword = random_password.reverse-proxy-password.result

  serial {
      id   = 0
      type = "socket"
    }

  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname ${self.name}"]

    connection {
      host = self.ssh_host
      type = "ssh"
      user = var.ssh_user
      private_key = "${file("./p_key")}"
    }
  }
}
