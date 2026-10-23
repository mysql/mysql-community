data "oci_identity_region_subscriptions" "my_home_region" {
  tenancy_id = var.tenancy_ocid

  filter {
    name   = "is_home_region"
    values = [true]
  }
}

locals {
   home_region = data.oci_identity_region_subscriptions.my_home_region.region_subscriptions[0].region_name
}
provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  region = var.region
  user_ocid = var.user_ocid
  fingerprint = var.fingerprint
  private_key_path = var.private_key_path
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  region = local.home_region
  user_ocid = var.user_ocid
  fingerprint = var.fingerprint
  private_key_path = var.private_key_path
  alias = "home"
}
