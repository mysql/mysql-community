output "public_ip" {
  value = join(", ", oci_core_instance.webserver.*.public_ip)
}

