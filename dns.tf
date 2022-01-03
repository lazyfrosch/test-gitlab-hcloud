variable "hetznerdns_token" {}

provider "hetznerdns" {
  apitoken = var.hetznerdns_token
}

data "hetznerdns_zone" "zone" {
  name = "lazyfrosch.de"
}
