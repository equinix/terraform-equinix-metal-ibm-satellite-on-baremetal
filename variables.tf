variable metal_api_auth_token {
  description = "Equinix Metal API Key"
  sensitive   = true
}

variable metal_create_project {
  type        = bool
  default     = true
  description = "Create a Metal Project if this is 'true'. Else use provided 'metal_project_id'"
}

variable metal_project_name {
  description = "The name of the project if 'metal_create_project' is 'true'."
  default     = "null"
}

variable metal_project_id {
  type        = string
  default     = "null"
  description = "Equinix Metal Project ID. Required if 'metal_create_project' is 'false'"
}

variable metal_organization_id {
  type        = string
  default     = "null"
  description = "Equinix Metal Organization ID"
}

variable "metal_device_reservations" {
  description = <<-EOF
  A map of hostnames to reservation ids. Any hostname not defined will use the default behavior of not using a reservation.
  Mapped values may be UUIDs of the hardware reservations where you want these devices deployed,
  'next-available' if you want to pick your next available reservation automatically, or an empty string.
  Warning: Please be careful when using hardware reservation UUID and next-available together for the same pool of reservations.
  It might happen that the reservation which Equinix Metal API will pick as next-available is the reservation which you
  refer with UUID in another metal_device resource. If that happens, and the metal_device with the UUID is created later,
  resource creation will fail because the reservation is already in use (by the resource created with next-available).
  Examples:
  - {"metal-ibm-sat-cp-01": "next-available"}
  - {"metal-ibm-sat-cp-01": "f3bf4e58-99e7-47ef-a0eb-8cbf727bc76f", "metal-ibm-sat-cp-02": "b3f6b4eb-64b9-4cf1-9e39-f11a8ba9da20"}
  EOF
  type        = map(any)
  default     = {}
}
variable metal_device_metro {
  description = "Equinix Metal metro location to deploy into"
  default     = "da"
}

variable control_plane_plan {
  description = "Equinix Metal device type to deploy control plane (manager) nodes"
  default     = "c3.small.x86"
}

variable data_plane_plan {
  description = "Equinix Metal device type to deploy for data plane (worker) nodes"
  default     = "c3.small.x86"
}

variable operating_system {
  description = "The Operating system of the node"
  default     = "rhel_7"
}

variable rhel_submanager_username {
  description = "RHEL subscription manager username"
  sensitive   = true
}

variable rhel_submanager_password {
  description = "RHEL subscription manager password"
  sensitive   = true
}

variable billing_cycle {
  description = "How the node will be billed (Not usually changed)"
  default     = "hourly"
}

variable stack_name {
  description = "Prefix to identify servers and resources belonging to this deployment"
  default     = "em-ibm-satellite"
}

// IBM
variable ibm_cloud_api_key {
  description = "The IBM Cloud platform API key"
  sensitive   = true
}

variable ibm_create_resource_group {
  type        = bool
  default     = false
  description = "Whether to create a resource group or use an existing one"
}

variable ibm_create_location {
  type         = bool
  default      = true
  description = "Whether to create a location or use an existing one"
}

variable ibm_cp_host_count {
  type           = number
  default        = 3
  description    = "The total number of baremetal host to create for control plane"
}

variable ibm_dp_host_count {
  type        = number
  default     = 3
  description = "The total number of baremetal host to create for data plane"
}

variable ibm_resource_group_name {
  description = "The name of the IBM resource group project. If 'ibm_create_resource_group' is true it will be created"
}

variable ibm_sat_location_name {
  description = "The name of the location to be created or pass existing location name"
}

variable ibm_sat_location_zones {
  type = list(string)
  default = ["zone-1", "zone-2", "zone-3"]
}

variable ibm_sat_managed_from {
  description = "To list available multizone regions, run 'ibmcloud ks locations'. such as 'wdc04', 'wdc06' or 'lon04'"
}

variable ibm_cp_host_labels {
  type = list(string)
  default = ["provider:equinix"]
  description = "Key:value pairs to label control plane hosts"

  validation {
      condition     = can([for s in var.ibm_cp_host_labels : regex("^[a-zA-Z0-9:]+$", s)])
      error_message = "Label must be of the form `key:value`."
  }
}

variable ibm_dp_host_labels {
  type = list(string)
  default = ["provider:equinix"]
  description = "Key:value pairs to label data plane hosts"

  validation {
      condition     = can([for s in var.ibm_dp_host_labels : regex("^[a-zA-Z0-9:]+$", s)])
      error_message = "Label must be of the form `key:value`."
  }
}

variable ibm_location_bucket {
  description = "(Optional) The name of the IBM Cloud Object Storage bucket that you want to use to back up the control plane data"
  default     = ""
}

variable ibm_region {
  description = "Region of the IBM Cloud account. Currently supported regions for satellite are us-east and eu-gb region."
  default     = "us-east"
}
