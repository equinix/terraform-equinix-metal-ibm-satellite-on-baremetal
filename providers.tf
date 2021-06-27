provider "metal" {
  auth_token = var.metal_api_auth_token
}

provider "ibm" {
  ibmcloud_api_key = var.ibm_cloud_api_key
  region           = var.ibm_region
}
