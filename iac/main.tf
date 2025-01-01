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

# Web - github pages
resource "cloudflare_record" "www-root-1" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "@"
  content = "185.199.108.153"
  type    = "A"
  proxied = true
  ttl     = 1 # Auto TTL
}

resource "cloudflare_record" "www-root-2" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "@"
  content = "185.199.109.153"
  type    = "A"
  proxied = true
  ttl     = 1 # Auto TTL
}

resource "cloudflare_record" "www-root-3" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "@"
  content = "185.199.110.153"
  type    = "A"
  proxied = true
  ttl     = 1 # Auto TTL
}

resource "cloudflare_record" "www-root-4" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "@"
  content = "185.199.111.153"
  type    = "A"
  proxied = true
  ttl     = 1 # Auto TTL
}

# Web - github pages
resource "cloudflare_record" "www6-root-1" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "@"
  content = "2606:50c0:8000::153"
  type    = "AAAA"
  proxied = true
  ttl     = 1 # Auto TTL
}

resource "cloudflare_record" "www6-root-2" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "@"
  content = "2606:50c0:8001::153"
  type    = "AAAA"
  proxied = true
  ttl     = 1 # Auto TTL
}

resource "cloudflare_record" "www6-root-3" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "@"
  content = "2606:50c0:8002::153"
  type    = "AAAA"
  proxied = true
  ttl     = 1 # Auto TTL
}

resource "cloudflare_record" "www6-root-4" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "@"
  content = "2606:50c0:8003::153"
  type    = "AAAA"
  proxied = true
  ttl     = 1 # Auto TTL
}

resource "cloudflare_record" "www-cname" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "www"
  content = "@"
  type    = "CNAME"
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

resource "cloudflare_record" "dkim" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "google._domainkey"
  content = "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvTjRMA5jN6+xOCsXoROFLXYNFbqMyN5q9FaQyn9YVrMPOs99QsHddXiFcQ0DcZESO9YYpUoxoqr41iJk4XsEcOmnM2hB181IfA+cnYjMcvSisY2DqlFjPzQuRL9T0x4Yx9BU0kepxgLdnj8lSUeipmYd8XTiYG/oaMJU7FiMkSqpzZdJ9ng/oEhgvdS7ln/1bHJYDVxMOYpaETQYw5izYdaMDM5GqAB+w7vHlBXUmBLakEdiCIGlKQGXQQR3SVwntXTQ/jBwQftMGyF4ys0wecuvjKvq5fhiaWYavQWW9Mp+6nNJ6l1b443G44lLWP0shUfsUlHQPx8Z4dYOva7WxQIDAQAB\""
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