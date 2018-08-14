resource "random_id" "rg_name" {
  byte_length = 8
}

resource "azurerm_resource_group" "diskRg" {
  name     = "${var.resource_group_name}-${random_id.rg_name.hex}"
  location = "${var.location}"
}

module "emptyDisk" {
  source               = "../../"
  managed_disk_name    = "myEmptyManagedDisk"
  resource_group_name  = "${azurerm_resource_group.diskRg.name}"
  disk_size_gb         = 1
  location             = "${var.location}"
  storage_account_type = "Standard_LRS"
}
