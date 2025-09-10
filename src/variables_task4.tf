### cloud vars

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

variable "default_vm_resources" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
  description = "https://yandex.cloud/ru/docs/data-proc/operations/cluster-create"

}


# ###ssh vars

# variable "vms_ssh_root_key" {
#   type        = string
#   default     = "~/.ssh/id_ed25519.pub"
#   description = "ssh-keygen -t ed25519"
# }


### vms

variable "networks" {
  description = "VPC network & subnet "
  type = map(object({
    name = string
    subnets = map(object({
      name           = string
      zone           = string
      network_id     = string
      v4_cidr_blocks = string
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
          network_id     = "", #"${var.net_project["net"].id}"
          v4_cidr_blocks = "[10.0.1.0/24]"
        },
        db = {
          name           = "sub-db"
          zone           = "ru-central1-b"
          network_id     = "", #"${var.net_project["net"].id}"
          v4_cidr_blocks = "[10.0.2.0/24]"
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
    resources = map(number)
  }))

  default = {
    # net = {
    #   name                    = "net-tf2",
    #   subnets                 = {
    #     name           = "sub-web"
    #     zone           = "ru-central1-a"
    #     network_id     = ""
    #     v4_cidr_blocks = "[10.0.1.0/24]"
    #   }
    # },
    web = {
      name      = "netology-develop-platform-web",
      platform  = "standard-v1",
      zone      = "ru-central1-a"
      subnet_id = "", #"${yandex_vpc_subnet.develop.id}"
      user      = "ubuntu"
      resource = {
        cores         = 2
        memory        = 1
        core_fraction = 5
      }
    },
    db = {
      name      = "netology-develop-platform-db",
      platform  = "standard-v1",
      zone      = "ru-central1-b"
      subnet_id = "", #"${yandex_vpc_subnet.db.id}"
      user      = "ubuntu"
      resource = {
        cores         = 2
        memory        = 1
        core_fraction = 5
      }
    }
  }
}

###vm vars
