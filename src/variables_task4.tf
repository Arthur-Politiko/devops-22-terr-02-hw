### cloud vars

# variable "cloud_id" {
#   type        = string
#   description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
# }

# variable "folder_id" {
#   type        = string
#   description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
# }

# variable "zone_a" {
#   type        = string
#   default     = "ru-central1-a"
#   description = "Zone A"
# }
# variable "zone_b" {
#   type        = string
#   default     = "ru-central1-b"
#   description = "Zone B"
# }

# variable "default_cidr" {
#   type        = list(string)
#   default     = ["10.0.1.0/24"]
#   description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
# }

# variable "vm_platform" {
#   type        = string
#   default     = "standard-v1"
#   description = "Default VM platform"
# }

# variable "vm_image_family" {
#   type       = string
#   default     = "ubuntu-2004-lts"
#   description = "Default VM image family"
# }

# variable "default_vm_resources" {
#   type = map(number)
#   default = {
#     cores         = 2
#     memory        = 1
#     core_fraction = 5
#   }
#   description = "https://yandex.cloud/ru/docs/data-proc/operations/cluster-create"

# }


# ###ssh vars

# variable "vms_ssh_root_key" {
#   type        = string
#   default     = "~/.ssh/id_ed25519.pub"
#   description = "ssh-keygen -t ed25519"
# }


### vms


locals {
  vms_ssh_root_key = "ubuntu:${file(var.vms_ssh_root_key)}"
  image_id = data.yandex_compute_image.ubuntu.image_id
}

variable "networks" {
  description = "VPC network & subnet "
  type = map(object({
    name = string
    subnets = map(object({
      name           = string
      zone           = string
      network_id     = string
      v4_cidr_blocks = list(string)
    }))
  }))

  default = {
    net = {
      name = "net-tf2",
      id   = "",
      subnets = {
        web = {
          name           = "sub-web"
          zone           = "ru-central1-a"
          network_id     = "" #"${var.net_project["net"].id}"
          v4_cidr_blocks = ["10.0.1.0/24"]
        },
        db = {
          name           = "sub-db"
          zone           = "ru-central1-b"
          network_id     = "" #"${var.net_project["net"].id}"
          v4_cidr_blocks = ["10.0.2.0/24"]
        }
      }
    },
  }
}

variable "vms" {
  description = "Map of project names to configuration."
  type = map(object({
    name      = string
    platform  = string
    zone      = string
    subnet_id = string
    user      = string
    resources = object({
      cores         = number
      memory        = number
      core_fraction = number
      hdd_size      = number
      hdd_type      = string
    })
    boot_disk = object({
      initialize_params = object({
        image_id = string
      })
    })
    scheduling_policy = object({
      preemptible = bool
    })
    metadata = object({
      serial-port-enable = string
      ssh-keys           = string
    })
    network_interface = object({
      subnet_name = string
      subnet_id = string
      nat       = bool
    })
  }))

  default = {
    web = {
      name      = "netology-platform-web",
      platform  = "standard-v1",
      zone      = "ru-central1-a"
      subnet_id = "", #"${yandex_vpc_subnet.develop.id}"
      user      = "ubuntu"
      resources = {
        cores         = 2
        memory        = 1
        core_fraction = 5
        hdd_size      = 10
        hdd_type      = "network-hdd"
      }
      boot_disk = {
        initialize_params = {
          image_id = "" #data.yandex_compute_image.ubuntu.image_id
        }
      }
      scheduling_policy = {
        preemptible = true
      }
      metadata = {
        serial-port-enable = "1"
        ssh-keys           = "" #locals.vms_ssh_root_key
      }
      network_interface = {
        subnet_name = "web"
        subnet_id = ""
        nat       = true
      }
    },
    db = {
      name      = "netology-platform-db",
      platform  = "standard-v1",
      zone      = "ru-central1-b"
      subnet_id = "", #"${yandex_vpc_subnet.db.id}"
      user      = "ubuntu"
      resources = {
        cores         = 2
        memory        = 1
        core_fraction = 5
        hdd_size      = 10
        hdd_type      = "network-ssd"
      }
      boot_disk = {
        initialize_params = {
          image_id = "" #data.yandex_compute_image.ubuntu.image_id
        }
      }
      scheduling_policy = {
        preemptible = true
      }
      metadata = {
        serial-port-enable = "1"
        ssh-keys           = "" #"ubuntu:${file(var.vms_ssh_root_key)}"
      }
      network_interface = {
        subnet_name = "db"
        subnet_id = ""
        nat       = true
      }
    }
  }
}

###vm vars
