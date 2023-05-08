locals {
  stack_name                  = format("%s-%s", var.stack_name, random_string.cluster_suffix.result)
  ssh_key_name                = format("%s-key-%s", var.stack_name, random_string.cluster_suffix.result)
  equinix_project_id            = var.equinix_create_project ? equinix_metal_project.new_project[0].id : var.equinix_project_id
  ibm_satellite_host_provider = "equinix"
}

resource "random_string" "cluster_suffix" {
  length  = 5
  special = false
  upper   = false
}
