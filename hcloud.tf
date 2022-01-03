variable "hcloud_token" {}

variable "admin_ssh_key" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

data "hcloud_ssh_key" "admin" {
  name = var.admin_ssh_key
}
