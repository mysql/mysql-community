output "webserver_public_ip" {
  value = "${module.webserver.public_ip}"
}

output "heatwave_private_ip" {
  value = local.deploy_heatwave ? module.heatwave[0].private_ip : null
}

output "autonomous_database_id" {
  value = local.deploy_autonomous_database ? oci_database_autonomous_database.autonomous_database[0].id : null
}

output "autonomous_database_service_console_url" {
  value = local.deploy_autonomous_database ? oci_database_autonomous_database.autonomous_database[0].service_console_url : null
}

output "ssh_private_key" {
  value = local.private_key_to_show
  sensitive = true
}
