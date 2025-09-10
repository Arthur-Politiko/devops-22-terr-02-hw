output "vms" {
  value = [for e in yandex_compute_instance.vm: {
    instance_name: e.name, 
    external_ip: e.network_interface[0].nat_ip_address, 
    fqdn: e.fqdn
  }]
}