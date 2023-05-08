output "Control_Plane_public_IPs" {
  value       = try(equinix_metal_device.control_plane.*.access_public_ipv4, "is not configured yet")
  description = "Control Plane Public IPs"
}

output "Worker_public_IPs" {
  value       = try(equinix_metal_device.data_plane.*.access_public_ipv4, "is not configured yet")
  description = "Worker Node Public IPs"
}

output "SSH_key_location" {
  value       = try(local_file.cluster_private_key_pem.filename, "is not configured yet")
  description = "The SSH Private Key File Location"
}

output "Equinix_project_ID" {
  value = local.equinix_project_id
  description = "The project ID used for this deployment"
}

output "IBM_satellite_generated_attach_script_cp" {
  value       = data.ibm_satellite_attach_host_script.script_cp.script_path
  description = "Directory path to store the generated script for control plane nodes"
}

output "IBM_satellite_generated_attach_script_dp" {
  value       = data.ibm_satellite_attach_host_script.script_dp.script_path
  description = "Directory path to store the generated script for data plane nodes"
}
