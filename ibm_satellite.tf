resource "ibm_resource_group" "group" {
  count = var.ibm_create_resource_group ? 1 : 0
  name  = var.ibm_resource_group_name
}

data "ibm_resource_group" "group" {
  name = var.ibm_resource_group_name
  depends_on = [
    ibm_resource_group.group
  ]
}

resource "ibm_satellite_location" "location" {
  count = var.ibm_create_location ? 1 : 0

  location          = var.ibm_sat_location_name
  zones             = var.ibm_sat_location_zones
  managed_from      = var.ibm_sat_managed_from
  resource_group_id = data.ibm_resource_group.group.id

  cos_config {
    bucket  = var.ibm_location_bucket != "" ? var.ibm_location_bucket : ""
    region  = var.ibm_region != "" ? var.ibm_region : ""
  }
}

data "ibm_satellite_location" "location" {
  location    = var.ibm_sat_location_name
  depends_on  = [
    ibm_satellite_location.location
  ]
}

// Control plane resources
resource "local_file" "script_cp_dir" {
  content   = "auto-generated folder"
  filename  = "${path.module}/.generated_ibm_satellite_script/cp/auto"
}

data "ibm_satellite_attach_host_script" "script_cp" {
  location      = data.ibm_satellite_location.location.id
  labels        = var.ibm_cp_host_labels
  host_provider = local.ibm_satellite_host_provider
  script_dir    = dirname(local_file.script_cp_dir.filename)
}

resource "ibm_satellite_host" "assign_host_cp" {
  count = var.ibm_cp_host_count

  depends_on = [
    null_resource.deploy_satellite_cluster_cp
  ]
  location      = data.ibm_satellite_location.location.id
  cluster       = data.ibm_satellite_location.location.id
  host_id       = metal_device.control_plane.*.hostname[count.index]
  zone          = element(var.ibm_sat_location_zones, count.index)
  host_provider = local.ibm_satellite_host_provider
}

// Data plane resources
resource "local_file" "script_dp_dir" {
  content  = "auto-generated folder"
  filename = "${path.module}/.generated_ibm_satellite_script/dp/auto"
}

data "ibm_satellite_attach_host_script" "script_dp" {
  location      = data.ibm_satellite_location.location.id
  labels        = var.ibm_dp_host_labels
  host_provider = local.ibm_satellite_host_provider
  script_dir    = dirname(local_file.script_dp_dir.filename)
}