variable "tenancy_ocid" {
  description = "Tenancy's OCID"
}

variable "user_ocid" {
  description = "User's OCID"
  default     = ""
}

variable "compartment_ocid" {
  description = "Compartment's OCID where VCN will be created. "
}

variable "region" {
  description = "OCI Region"
}

variable "existing_vcn_ocid" {
  description = "OCID of an existing VCN to use"
  default     = ""
}

variable "existing_public_subnet_ocid" {
  description = "OCID of an existing public subnet to use"
  default     = ""
}

variable "existing_internet_gateway_ocid" {
  description = "OCID of an existing internet gateway to use"
  default     = ""
}

variable "existing_private_route_table_ocid" {
  description = "OCID of an existing private route table to use"
  default     = ""
}

variable "existing_private_security_list_ocid" {
  description = "OCID of an existing private security list allowing MySQL access to use"
  default     = ""
}

variable "existing_private_subnet_ocid" {
  description = "OCID of an existing private subnet to use"
  default     = ""
}

variable "existing_nat_gateway_ocid" {
  description = "OCID of an existing NAT gateway to use"
  default     = ""
}


variable "existing_public_route_table_ocid" {
  description = "OCID of an existing public route table to use"
  default     = ""
}

variable "existing_public_security_list_ocid" {
  description = "OCID of an existing public security list (ssh) to use"
  default     = ""
}

variable "existing_public_security_list_http_ocid" {
  description = "OCID of an existing security list allowing https and https to use"
  default     = ""
}

variable "existing_mds_instance_ocid" {
  description = "OCID of an existing MySQL HeatWave instance to use"
  default     = ""
}
variable "vcn" {
  description = "VCN Name"
  default     = "mysql_vcn"
}

variable "vcn_cidr" {
  description = "VCN's CIDR IP Block"
  default     = "10.0.0.0/16"
}

variable "fingerprint" {
  description = "Key Fingerprint"
  default     = ""
}

variable "dns_label" {
  description = "Allows assignment of DNS hostname when launching an Instance. "
  default     = ""
}

variable "node_image_id" {
  description = "The OCID of an image for a node instance to use. "
  default     = ""
}

variable "node_shape" {
  description = "Instance shape to use as Webserver. "
  default     = "VM.Standard.E5.Flex"
}

variable "node_flex_shape_ocpus" {
  description = "Flex Instance shape OCPUs"
  default     = 1
}

variable "node_flex_shape_memory" {
  description = "Flex Instance shape Memory (GB)"
  default     = 4
}

variable "useCredits" {
  type    = bool
  default = false
}

variable "database_deployment" {
  description = "Databases to deploy: MySQL HeatWave, Autonomous DB, or Both."
  type        = string
  default     = "Both"

  validation {
    condition     = contains(["MySQL HeatWave", "Autonomous DB", "Both"], var.database_deployment)
    error_message = "database_deployment must be MySQL HeatWave, Autonomous DB, or Both."
  }
}

variable "mysql_shape" {
  description = "MySQL HeatWave DBSystem shape to use. "
  default     = "MySQL.8"
}

variable "mysql_heatwave_display_name" {
  description = "Display name for the MySQL HeatWave DB System."
  type        = string
  default     = "Hackathon MySQL HeatWave"
}

variable "label_prefix" {
  description = "To create unique identifier for multiple setup in a compartment."
  default     = ""
}

variable "admin_password" {
  description = "Password for the root user for MySQL Database Service"
  default     = "MyPassw0rd!"
}

variable "autonomous_database_name" {
  description = "Unique database name for the Autonomous Database (letters and numbers only, starting with a letter)."
  type        = string
  default     = "HACKATHONADB"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9]{0,29}$", var.autonomous_database_name))
    error_message = "autonomous_database_name must start with a letter and contain at most 30 letters and numbers."
  }
}

variable "autonomous_database_display_name" {
  description = "Display name for the Autonomous Database."
  type        = string
  default     = "Hackathon Autonomous Database"
}

variable "autonomous_database_compute_count" {
  description = "Number of ECPUs for the paid Autonomous Database. The smallest standard serverless configuration uses 2 ECPUs."
  type        = number
  default     = 2

  validation {
    condition     = var.autonomous_database_compute_count >= 2
    error_message = "autonomous_database_compute_count must be at least 2 ECPUs."
  }
}

variable "autonomous_database_storage_size_in_gb" {
  description = "Storage in GB for the paid Autonomous Database."
  type        = number
  default     = 20

  validation {
    condition     = var.autonomous_database_storage_size_in_gb >= 20
    error_message = "autonomous_database_storage_size_in_gb must be at least 20 GB."
  }
}

variable "autonomous_database_admin_password" {
  description = "Optional password for the Autonomous Database ADMIN user. Defaults to admin_password when empty."
  type        = string
  default     = ""
  sensitive   = true
}

variable "ssh_authorized_keys_path" {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance. DO NOT FILL WHEN USING REOSURCE MANAGER STACK!"
  default     = ""
}

variable "ssh_private_key_path" {
  description = "The private key path to access instance. DO NOT FILL WHEN USING RESOURCE MANAGER STACK!"
  default     = ""
}

variable "private_key_path" {
  description = "The private key path to pem. DO NOT FILL WHEN USING RESOURCE MANAGER STACK! "
  default     = ""
}

variable "web_instance_name" {
  description = "Name of the web instance to be created"
  default     = "Webserver"
}

variable "admin_username" {
  description = "Username of the MySQL HeatWave admin account"
  default     = "admin"
}
