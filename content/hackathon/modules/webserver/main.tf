## DATASOURCE
# Init Script Files

locals {
  server_cloud_init = file("${path.module}/scripts/install_shell.sh")
}


resource "oci_core_instance" "webserver" {
  compartment_id      = var.compartment_ocid
  display_name        = "${var.label_prefix}${var.display_name}"
  shape               = var.shape
  availability_domain = var.availability_domains[0]

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.flex_shape_memory
      ocpus         = var.flex_shape_ocpus
    }
  }


  create_vnic_details {
    subnet_id        = var.subnet_id
    display_name     = "${var.label_prefix}${var.display_name}"
    assign_public_ip = var.assign_public_ip
    hostname_label   = var.display_name
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data           = base64encode(local.server_cloud_init)
  }

  source_details {
    source_id   = var.image_id
    source_type = "image"
  }

  timeouts {
    create = "10m"

  }
}
