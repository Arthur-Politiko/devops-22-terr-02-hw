###vm vars

variable "vpc_db_name" {
  type        = string
  default     = "db"
  description = "VPC network & subnet name"
}

# https://cloud.yandex.ru/docs/overview/concepts/geo-scope
variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "VM zone"
}

# https://cloud.yandex.ru/docs/vpc/operations/subnet-create
variable "vm_db_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "VM subnet CIDR"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-db-platform-web"
  description = "VM name"
}

# https://yandex.cloud/ru/docs/compute/concepts/vm-platforms
variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "VM platform version"
}

# https://cloud.yandex.ru/docs/compute/concepts/images
variable "vm_db_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "VM image family"
}

# https://yandex.cloud/ru/docs/data-proc/operations/cluster-create
variable "vm_db_resources" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
  description = "VM resources"

}