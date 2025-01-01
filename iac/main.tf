# Configure the Cloudflare provider
terraform {

  backend "s3" {
    bucket = "iac-tfstate"
    key    = "terraform.tfstate"
    region = "us-east-1" // cloudflare uses this as a filler: https://developers.cloudflare.com/r2/api/s3/api/#bucket-region
    access_key = ""
    secret_key = ""
    endpoint = ""
    skip_credentials_validation = true
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# Variables
variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Domain name"
  type        = string
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Data source for the zone ID
data "cloudflare_zones" "domain" {
  filter {
    name = var.domain
  }
}

# Web
resource "cloudflare_record" "www-root" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "@"
  content = "103.209.24.16"
  type    = "A"
  proxied = true
  ttl     = 1 # Auto TTL
}

resource "cloudflare_record" "www" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "www"
  content = "103.209.24.16"
  type    = "A"
  proxied = true
  ttl     = 1 # Auto TTL
}

# Gmail MX Records
resource "cloudflare_record" "gmail_mx_1" {
  zone_id  = data.cloudflare_zones.domain.zones[0].id
  name     = "@"
  content  = "aspmx.l.google.com"
  type     = "MX"
  priority = 1
  proxied  = false
  ttl      = 3600
}

resource "cloudflare_record" "gmail_mx_2" {
  zone_id  = data.cloudflare_zones.domain.zones[0].id
  name     = "@"
  content  = "alt1.aspmx.l.google.com"
  type     = "MX"
  priority = 5
  proxied  = false
  ttl      = 3600
}

resource "cloudflare_record" "gmail_mx_3" {
  zone_id  = data.cloudflare_zones.domain.zones[0].id
  name     = "@"
  content  = "alt2.aspmx.l.google.com"
  type     = "MX"
  priority = 5
  proxied  = false
  ttl      = 3600
}

resource "cloudflare_record" "gmail_mx_4" {
  zone_id  = data.cloudflare_zones.domain.zones[0].id
  name     = "@"
  content  = "alt3.aspmx.l.google.com"
  type     = "MX"
  priority = 10
  proxied  = false
  ttl      = 3600
}

resource "cloudflare_record" "gmail_mx_5" {
  zone_id  = data.cloudflare_zones.domain.zones[0].id
  name     = "@"
  content  = "alt4.aspmx.l.google.com"
  type     = "MX"
  priority = 10
  proxied  = false
  ttl      = 3600
}

resource "cloudflare_record" "gmail_spf" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "@"
  content = "\"v=spf1 include:_spf.google.com ~all\""
  type    = "TXT"
  proxied = false
  ttl     = 3600
}

resource "cloudflare_record" "dmarc" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "_dmarc"
  content = "\"v=DMARC1; p=quarantine; rua=mailto:dmarc@${var.domain}\""
  type    = "TXT"
  proxied = false
  ttl     = 3600
}


resource "cloudflare_record" "cname_calendar" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "calendar"
  content = "ghs.googlehosted.com"
  type    = "CNAME"
  proxied = false
  ttl     = 1 # Auto TTL
}

resource "cloudflare_record" "cname_mail" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "mail"
  content = "ghs.googlehosted.com"
  type    = "CNAME"
  proxied = false
  ttl     = 1 # Auto TTL
}

resource "cloudflare_record" "cname_drive" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "drive"
  content = "ghs.googlehosted.com"
  type    = "CNAME"
  proxied = false
  ttl     = 1 # Auto TTL
}