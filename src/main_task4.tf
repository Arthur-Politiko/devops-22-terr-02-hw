# Для того чтобы устранить "хардкод" из переменных, всю структуру 
# необходимо создавать динамически. То есть, наши ВМ должны быть в массиве, а потом
# используя for_each создавать нужное количество ВМ.
# Подорбнее: 
# https://developer.hashicorp.com/terraform/language/meta-arguments#for_each
# https://developer.hashicorp.com/terraform/tutorials/configuration-language/for-each

# Ну и конечно Модули. 
# Как подключать описано тут: https://yandex.cloud/ru/docs/vpc/tutorials/terraform-modules
# И тут https://developer.hashicorp.com/terraform/language/block/module

# Короче, можно и не через модули, а просто используя for_each в resource,

resource "yandex_compute_instance" "vm" {
  for_each = var.vms
  
  name        = each.key  # "web", "db"
  platform_id = each.platform # "standard-v1"
  zone        = each.zone     # "ru-central1-a", "ru-central1-b"

  resources {
    cores  = each.value.cores   # 
    memory = each.value.memory  # 
    core_fraction = each.value.core_fraction # 
  }

}

# module "vpc-instance" {
#   source              = "github.com/terraform-yc-modules/terraform-yc-vpc"

#   network_name        = var.network.net.name
#   network_description = "Test network created with module"
  
#   for_each = var.network.net.subnets

#   private_subnets.name           = each.value.name
#   private_subnets.zone           = each.value.zone
#   private_subnets.v4_cidr_blocks = each.value.v4_cidr_blocks
# }

# module "compute_instance" {
#   source   = "github.com/terraform-yc-modules/terraform-yc-compute-instance"
#   for_each = var.vms

#   description = "description"
#   name        = each.value.name
#   zone        = each.value.zone
#   #hostname         =

#   memory             = var.default_vm_resources.memory
#   gpus               = 0
#   cores              = var.default_vm_resources.cores
#   core_fraction      = var.default_vm_resources.core_fraction
#   serial_port_enable = true
#   #allow_stopping_for_update = true
#   #monitoring                = true
#   backup = false
#   # boot_disk = {
#   #   size        = 30
#   #   block_size  = 4096
#   #   type        = "network-ssd"
#   #   image_id    = null
#   #   snapshot_id = null
#   # }
#   # secondary_disks = [
#   #   {
#   #     disk_id     = null
#   #     auto_delete = true
#   #     device_name = "secondary-disk"
#   #     mode        = "READ_WRITE"
#   #     size        = 100
#   #     block_size  = 4096
#   #     type        = "network-hdd"
#   #   }
#   # ]
#   # filesystems = [
#   #   {
#   #     filesystem_id = null
#   #     mode          = "READ_WRITE"
#   #     zone          = "ru-central1-a"
#   #   }
#   # ]

#   # Authentication - either use OS Login
#   # enable_oslogin_or_ssh_keys = {
#   #   enable-oslogin = "true"
#   # }

#   # Or use SSH keys
#   enable_oslogin_or_ssh_keys = {
#     ssh_user = each.value.user
#     ssh_key  = var.vms_ssh_root_key
#   }
#   network_interfaces = [
#     {
#       subnet_id = each.value.subnet_id
#       #  ipv4      = true
#       #  nat       = true

#     },
#     # {
#     #   subnet_id  = yandex_vpc_subnet.db.id
#     #   ipv4       = true
#     #   nat        = false
#     #   dns_record = []
#     # }
#   ]

#   # static_ip = {
#   #   name        = "my-static-ip"
#   #   description = "Static IP for dev instance"
#   #   external_ipv4_address = {
#   #     zone_id = "ru-central1-a"
#   #   }
#   # }
# }

