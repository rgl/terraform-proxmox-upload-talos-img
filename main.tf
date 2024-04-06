# see https://github.com/hashicorp/terraform
terraform {
  required_version = "1.7.5"
  required_providers {
    # see https://registry.terraform.io/providers/bpg/proxmox
    # see https://github.com/bpg/terraform-provider-proxmox
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.51.1"
    }
  }
}

provider "proxmox" {
  tmp_dir = "tmp"
  ssh {
    node {
      name    = var.proxmox_pve_node_name
      address = var.proxmox_pve_node_address
    }
  }
}

variable "proxmox_pve_node_name" {
  type    = string
  default = "pve"
}

variable "proxmox_pve_node_address" {
  type = string
}

# see https://github.com/siderolabs/talos/releases
# see https://www.talos.dev/v1.6/introduction/support-matrix/
variable "talos_version" {
  type = string
  # renovate: datasource=github-releases depName=siderolabs/talos
  default = "1.6.7"
  validation {
    condition     = can(regex("^\\d+(\\.\\d+)+", var.talos_version))
    error_message = "Must be a version number."
  }
}

# see https://registry.terraform.io/providers/bpg/proxmox/0.51.1/docs/resources/virtual_environment_file
resource "proxmox_virtual_environment_file" "talos" {
  datastore_id = "local"
  node_name    = "pve"
  content_type = "iso"
  source_file {
    path      = "tmp/talos/talos-${var.talos_version}.qcow2"
    file_name = "talos-${var.talos_version}.img"
  }
}
