output "internal_ip_address_vm" {
  #value = [for instance in yandex_compute_instance : instance.network_interface.0.ip_address]
  #value = yandex_compute_instance.*.network_interface.0.ip_address
  value = "yandex_compute_instance.platform"
}