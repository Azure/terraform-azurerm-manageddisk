#Azure Managed Disk Module
data "azurerm_resource_group" "passed" {
  name = var.resource_group_name
}

locals {
  # set flags depending on inputs
  import_vhd = length(var.source_uri) > 0 ? 1 : 0
  copy_disk  = length(var.source_resource_id) > 0 ? 1 : 0
  copy_image = length(var.image_reference_id) > 0 ? 1 : 0

  # if exactly one of the previous is set, then not empty disk, but import or copy as denoted.
  # if 0 or >1 of the previous set, default to empty disk.
  create_empty = local.import_vhd + local.copy_disk + local.copy_image == 1 ? 0 : 1

  # figure out the create_option for the azurerm_managed_disk resource
  create_option = local.create_empty == 1 ? "Empty" : (local.import_vhd == 1 ? "Import" : (local.copy_disk == 1 ? "Copy" : "FromImage"))
}

resource "azurerm_managed_disk" "disk" {
  name                = var.managed_disk_name
  resource_group_name = data.azurerm_resource_group.passed.name

  # you can put the managed disk in another location
  # if you don't specify location, it'll be created in resource group location
  location = coalesce(var.location, data.azurerm_resource_group.passed.location)

  storage_account_type = var.storage_account_type
  create_option        = local.create_option
  source_uri           = var.source_uri
  source_resource_id   = var.source_resource_id
  image_reference_id   = var.image_reference_id
  disk_size_gb         = var.disk_size_gb
}
