variable "gitlab_root_password" {
  sensitive = true
  default   = ""
}

resource "hcloud_server" "gitlab" {
  name        = "gittest.lazyfrosch.de"
  image       = "debian-11"
  location    = "fsn1"
  server_type = "cx21"
  ssh_keys    = [data.hcloud_ssh_key.admin.id]

  lifecycle {
    ignore_changes = [
      user_data
    ]
  }

  user_data = templatefile("user-data.yml", {
    gitlab_fqdn          = "gittest.lazyfrosch.de",
    gitlab_root_password = var.gitlab_root_password,
  })
}

resource "hetznerdns_record" "gitlab" {
  zone_id = data.hetznerdns_zone.zone.id
  name    = "gittest" # gittest.lazyfrosch.de
  value   = hcloud_server.gitlab.ipv4_address
  type    = "A"
  ttl     = 300
}

resource "hetznerdns_record" "gitlab6" {
  zone_id = data.hetznerdns_zone.zone.id
  name    = "gittest" # gittest.lazyfrosch.de
  value   = hcloud_server.gitlab.ipv6_address
  type    = "AAAA"
  ttl     = 300
}

resource "hcloud_rdns" "gitlab" {
  server_id  = hcloud_server.gitlab.id
  ip_address = hcloud_server.gitlab.ipv4_address
  dns_ptr    = "gittest.lazyfrosch.de"
}

resource "hetznerdns_record" "registrytest" {
  zone_id = data.hetznerdns_zone.zone.id
  name    = "registrytest" # registrytest.lazyfrosch.de
  value   = hcloud_server.gitlab.ipv4_address
  type    = "A"
  ttl     = 300
}

resource "hetznerdns_record" "registrytest6" {
  zone_id = data.hetznerdns_zone.zone.id
  name    = "registrytest" # registrytest.lazyfrosch.de
  value   = hcloud_server.gitlab.ipv6_address
  type    = "AAAA"
  ttl     = 300
}
