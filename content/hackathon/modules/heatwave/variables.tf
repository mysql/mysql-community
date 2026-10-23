variable "compartment_ocid" {
  description = "Compartment's OCID where VCN will be created. "
}

variable "availability_domain" {
  description = "The Availability Domain of the instance. "
  default     = ""
}

variable "display_name" {
  description = "The name of the instance. "
  default     = ""
}

variable "subnet_id" {
  description = "The OCID of the master subnet to create the VNIC in. "
  default     = ""
}

variable "mysql_shape" {
  description = "Instance shape to use."
  default     = "MySQL.2"
}

variable "admin_username" {
    description = "Username of the MySQL HeatWave admin account"
    default     = "admin"
}

variable "admin_password" {
    description = "Password for the admin user for MySQL HeatWave"
}

variable "configuration_id" {
    description = "MySQL Instance Configuration ID"
}

variable "mysql_data_storage_in_gb" {
    default = 50
}

variable "existing_mds_instance_id" {
  description = "OCID of an existing MDS instance to use"
  default     = ""
}

variable "mysql_version" {
   default = "26.7.0"
}
