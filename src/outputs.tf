output "vms" {
  value = [for e in yandex_compute_instance.vm: {
    instance_name: e.name, 
    external_ip: e.network_interface[0].nat_ip_address, 
    fqdn: e.fqdn
  }]
}

output "task7" {
  value = <<EOT
  ${values(local.test_map)[0]} is ${keys(local.test_map)[0]} 
  for ${keys(local.servers)[1]} server based on ${values(local.servers)[1].image} 
  with ${values(local.servers)[1].cpu} vcpu, ${values(local.servers)[1].ram} GB ram 
  and ${length(values(local.servers)[1].disks)} virtual disks
  EOT
}
