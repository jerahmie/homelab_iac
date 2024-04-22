# Instruct terraform to download the provider on terraform init.
terraform {
  required_providers {
    xenorchestra = {
      source = "registry.terraform.io/terra-farm/xenorchestra"
    }
  }
}


# Create a test vm in terraform

provider "xenorchestra" {
  # Must be ws or wss
  url = "ws://192.168.1.71"
  username = "admin@admin.net"
  password = ""
  insecure = true
}

data "xenorchestra_pool" "localhost" {
  name_label = "localhost"
}

data "xenorchestra_sr" "local_storage" {
  pool_id = data.xenorchestra_pool.localhost.id
  name_label = "Local storage"
}

data "xenorchestra_template" "template" {
  name_label = "Ubuntu Jammy Jellyfish 22.04"
}

data "xenorchestra_network" "net" {
  name_label = "Pool-wide network associated with eth1"
}

#data "xenserver_pif" "management" {
#  management = "true"
#}
#

resource "xenorchestra_vm" "demo-vm" {

  template = data.xenorchestra_template.template.id
  memory_max = 1073733632
  cpus = 1
  name_label = "demo-vm01"
  network {
	network_id = data.xenorchestra_network.net.id
  }
  disk {
    sr_id = data.xenorchestra_sr.local_storage.id
    name_label = "Ubuntu Jammy Jellyfish 22.04-demo-vm"
    size = 32212254720
  }
}
