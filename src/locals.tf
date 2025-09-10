locals {
  vm_web_name = "${var.project}-${var.platform}-${var.stage}-web"
  vm_db_name  = "${var.project}-${var.platform}-${var.stage}-db"
}