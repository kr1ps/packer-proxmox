# Ubuntu Server jammy
# ---
# Packer Template to create an Ubuntu Server (jammy) on Proxmox

# Variable Definitions
variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

# Resource Definiation for the VM Template
source "proxmox" "ubuntu-server-template" {
 
    # Proxmox Connection Settings
    proxmox_url = "${var.proxmox_api_url}"
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"
    # (Optional) Skip TLS Verification
    insecure_skip_tls_verify = true
    
    # VM General Settings
    node = "pve01"
    #vm_id = "100"
    vm_name = "ubuntu-server-2204-template"
    template_description = "Ubuntu Server jammy Image"

    # VM OS Settings
    # (Option 1) Local ISO File
    iso_file = "local:iso/ubuntu-22.04.1-server-amd64.iso"
    # - or -
    # (Option 2) Download ISO
    # iso_url = "https://releases.ubuntu.com/22.04/ubuntu-22.04-live-server-amd64.iso"
    # iso_checksum = "84aeaf7823c8c61baa0ae862d0a06b03409394800000b3235854a6b38eb4856f"
    iso_storage_pool = "local"
    unmount_iso = true

    # VM System Settings
    qemu_agent = true

    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"

    disks {
        disk_size = "120G"
        format = "raw"
        storage_pool = "local-lvm"
        storage_pool_type = "lvmthin"
        type = "virtio"
    }

    # VM CPU Settings
    cores = "4"
    
    # VM Memory Settings
    memory = "4096" 

    # VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
    } 

    # VM Cloud-Init Settings
    cloud_init = true
    cloud_init_storage_pool = "local-lvm"

    # PACKER Boot Commands
    boot_command = [
        "<esc><wait>",
        "e<wait>",
        "<down><down><down><end>",
        "<bs><bs><bs><bs><wait>",
        "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
        "<f10><wait>"
    ]
    boot = "c"
    boot_wait = "5s"

    # PACKER Autoinstall Settings
    http_directory = "./ubuntu-server-template/http" 
    http_bind_address = "172.18.0.237"
    


    ssh_username = "test"

    # (Option 1) Add your Password here
    ssh_password = "test"
    # - or -
    # (Option 2) Add your Private SSH KEY file here
    # ssh_private_key_file = "~/.ssh/id_rsa"

    # Raise the timeout, when installation takes longer
    ssh_timeout = "20m"
}

# Build Definition to create the VM Template
build {

    name = "ubuntu-server-template"
    sources = ["source.proxmox.ubuntu-server-template"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            # "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo sync"
        ]
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "./ubuntu-server-template/files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }

    # Add additional provisioning scripts here
    # ...
}
