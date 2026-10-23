
locals {
  vcn_id                       = var.existing_vcn_ocid == "" ? oci_core_virtual_network.starter_vcn[0].id : var.existing_vcn_ocid
  internet_gateway_id          = var.existing_internet_gateway_ocid == "" ? oci_core_internet_gateway.internet_gateway[0].id : var.existing_internet_gateway_ocid
  nat_gateway_id = var.existing_nat_gateway_ocid != "" ? var.existing_nat_gateway_ocid : try(oci_core_nat_gateway.nat_gateway[0].id, null)
  public_route_table_id        = var.existing_public_route_table_ocid == "" ? oci_core_route_table.public_route_table[0].id : var.existing_public_route_table_ocid
  public_subnet_id             = var.existing_public_subnet_ocid == "" ? oci_core_subnet.public[0].id : var.existing_public_subnet_ocid
  public_security_list_id      = var.existing_public_security_list_ocid == "" ? oci_core_security_list.public_security_list[0].id : var.existing_public_security_list_ocid
  public_security_list_http_id = var.existing_public_security_list_http_ocid == "" ? oci_core_security_list.public_security_list_http[0].id : var.existing_public_security_list_http_ocid
  private_route_table_id = var.existing_private_route_table_ocid != "" ? var.existing_private_route_table_ocid : try(oci_core_route_table.private_route_table[0].id, null)
  private_subnet_id            = var.existing_private_subnet_ocid == "" ? oci_core_subnet.private[0].id : var.existing_private_subnet_ocid
  private_security_list_id     = var.existing_private_security_list_ocid == "" ? oci_core_security_list.private_security_list[0].id : var.existing_private_security_list_ocid
  ssh_key                      = var.ssh_authorized_keys_path == "" ? tls_private_key.public_private_key_pair.public_key_openssh : file(var.ssh_authorized_keys_path)
  ssh_private_key              = var.ssh_private_key_path == "" ? tls_private_key.public_private_key_pair.private_key_pem : file(var.ssh_private_key_path)
  private_key_to_show          = var.ssh_private_key_path == "" ? local.ssh_private_key : var.ssh_private_key_path
  effective_mysql_shape = (
    var.mysql_shape != null ? var.mysql_shape :
    var.useCredits ? "MySQL.Free" : "MySQL.8"
  )
  effective_autonomous_database_admin_password = (
    var.autonomous_database_admin_password != "" ?
    var.autonomous_database_admin_password : var.admin_password
  )
  deploy_heatwave            = contains(["MySQL HeatWave", "Both"], var.database_deployment)
  deploy_autonomous_database = contains(["Autonomous DB", "Both"], var.database_deployment)
}


data "oci_core_images" "images_for_shape" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = var.node_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_identity_availability_domains" "ad" {
  compartment_id = var.tenancy_ocid
}

resource "oci_core_virtual_network" "starter_vcn" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = var.vcn
  dns_label      = "startervcn"

  count = var.existing_vcn_ocid == "" ? 1 : 0
}


resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "internet_gateway"
  vcn_id         = local.vcn_id

  count = var.existing_internet_gateway_ocid == "" ? 1 : 0
}

resource "oci_core_route_table" "public_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = local.vcn_id
  display_name   = "RouteTableForMySQLPublic"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = local.internet_gateway_id
  }

  count = var.existing_public_route_table_ocid == "" ? 1 : 0
}

resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = local.vcn_id
  display_name   = "nat_gateway"

  count = (
    var.existing_nat_gateway_ocid == "" && var.useCredits
  ) ? 1 : 0
}


resource "oci_core_route_table" "private_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = local.vcn_id
  display_name   = "RouteTableForMySQLPrivate"

  dynamic "route_rules" {
    for_each = local.nat_gateway_id != null ? [local.nat_gateway_id] : []
    content {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = route_rules.value
    }
  }

  count = (
    var.existing_private_route_table_ocid == "" && var.useCredits
  ) ? 1 : 0
}

resource "oci_core_security_list" "public_security_list" {
  compartment_id = var.compartment_ocid
  display_name   = "Allow Public SSH Connections to Webserver"
  vcn_id         = local.vcn_id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }
  ingress_security_rules {
    tcp_options {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }

  count = var.existing_public_security_list_ocid == "" ? 1 : 0
}

resource "oci_core_security_list" "public_security_list_http" {
  compartment_id = var.compartment_ocid
  display_name   = "Allow HTTP(S) to WebServer"
  vcn_id         = local.vcn_id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }
  ingress_security_rules {
    tcp_options {
      max = 80
      min = 80
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    tcp_options {
      max = 443
      min = 443
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }

  count = var.existing_public_security_list_http_ocid == "" ? 1 : 0
}

resource "oci_core_security_list" "private_security_list" {
  compartment_id = var.compartment_ocid
  display_name   = "Private"
  vcn_id         = local.vcn_id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
  ingress_security_rules {
    protocol = "1"
    source   = var.vcn_cidr
  }
  ingress_security_rules {
    tcp_options {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = var.vcn_cidr
  }
  ingress_security_rules {
    tcp_options {
      max = 3306
      min = 3306
    }
    protocol = "6"
    source   = var.vcn_cidr
  }
  ingress_security_rules {
    tcp_options {
      max = 33061
      min = 33060
    }
    protocol = "6"
    source   = var.vcn_cidr
  }

  ingress_security_rules {
    tcp_options {
      max = 443
      min = 443
    }
    protocol = "6"
    source   = var.vcn_cidr
  }

  count = var.existing_private_security_list_ocid == "" ? 1 : 0
}


resource "tls_private_key" "public_private_key_pair" {
  algorithm = "RSA"
}

resource "oci_core_subnet" "public" {
  cidr_block        = cidrsubnet(var.vcn_cidr, 8, 0)
  display_name      = "mysql_public_subnet"
  compartment_id    = var.compartment_ocid
  vcn_id            = local.vcn_id
  route_table_id    = local.public_route_table_id
  security_list_ids = [local.public_security_list_id, local.public_security_list_http_id]
  dns_label         = "mysqlpub"

  count = var.existing_public_subnet_ocid == "" ? 1 : 0
}

resource "oci_core_subnet" "private" {
  cidr_block        = cidrsubnet(var.vcn_cidr, 8, 1)
  display_name      = "mysql_private_subnet"
  compartment_id    = var.compartment_ocid
  vcn_id            = local.vcn_id
  route_table_id    = local.private_route_table_id
  security_list_ids = [local.private_security_list_id]
  #dhcp_options_id = var.use_existing_vcn_ocid ? var.existing_vcn_ocid.default_dhcp_options_id : oci_core_virtual_network.mysqlvcn[0].default_dhcp_options_id
  prohibit_public_ip_on_vnic = "true"
  dns_label                  = "mysqlpriv"

  count = var.existing_private_subnet_ocid == "" ? 1 : 0

}


module "webserver" {
  source               = "./modules/webserver"
  availability_domains = data.oci_identity_availability_domains.ad.availability_domains[*].name
  compartment_ocid     = var.compartment_ocid
  image_id             = var.node_image_id == "" ? data.oci_core_images.images_for_shape.images[0].id : var.node_image_id
  shape                = var.node_shape
  label_prefix         = var.label_prefix
  subnet_id            = local.public_subnet_id
  ssh_authorized_keys  = local.ssh_key
  ssh_private_key      = local.ssh_private_key
  display_name         = var.web_instance_name
  flex_shape_ocpus     = var.node_flex_shape_ocpus
  flex_shape_memory    = var.node_flex_shape_memory
}

data "oci_mysql_mysql_configurations" "shape" {
  compartment_id = var.compartment_ocid
  type           = ["DEFAULT"]
  shape_name     = local.effective_mysql_shape

  count = local.deploy_heatwave ? 1 : 0
}


module "heatwave" {
  count                    = local.deploy_heatwave ? 1 : 0
  source                   = "./modules/heatwave"
  admin_password           = var.admin_password
  admin_username           = var.admin_username
  availability_domain      = data.oci_identity_availability_domains.ad.availability_domains[0].name
  configuration_id         = data.oci_mysql_mysql_configurations.shape[0].configurations[0].id
  compartment_ocid         = var.compartment_ocid
  subnet_id                = local.private_subnet_id
  existing_mds_instance_id = var.existing_mds_instance_ocid
  mysql_shape              = local.effective_mysql_shape
  display_name             = var.mysql_heatwave_display_name
}

resource "oci_database_autonomous_database" "autonomous_database" {
  count                       = local.deploy_autonomous_database ? 1 : 0
  compartment_id              = var.compartment_ocid
  admin_password              = local.effective_autonomous_database_admin_password
  db_name                     = var.autonomous_database_name
  display_name                = var.autonomous_database_display_name
  db_workload                 = "OLTP"
  compute_model               = "ECPU"
  compute_count               = var.autonomous_database_compute_count
  data_storage_size_in_gb     = var.autonomous_database_storage_size_in_gb
  is_free_tier                = false
  is_mtls_connection_required = true
}
