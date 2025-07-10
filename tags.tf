locals {

  ## Azure tags
  ## A maximum of 15 tags are allowed with keys no longer than 512 and values no longer than 256 characters.
  tags_default = {
    type        = contains(["production", "live"], var.landing_zone_name) ? "permanent" : "temporary"
    environment = var.landing_zone_name
    costcentre  = var.cost_centre
    data_PII    = var.data_pii
    data_PHI    = var.data_phi
    project     = var.owner
    project     = var.project_name
    application = var.application_name
    createdby   = "terraform"
    monitoring  = var.monitoring
    created     = formatdate("DD/MM/YYYY", timestamp())
  }
}

locals {
  ## DNS SOE Record tags
  dns_tags_private = {
    type = "private" ## private, public
    use  = "private-records"
  }
  dns_tags_public = {
    type = "public" ## private, public
    use  = "public-records"
  }
}
