output "managed_disk_id" {
  description = "The id of the newly created managed disk"
  value       = "${azurerm_managed_disk.disk.id}"
}

output "import_vhd" {
  description = "Says that a source_uri was provided."
  value       = "${local.import_vhd}"
}

output "copy_disk" {
  description = "Says that a source_resource_id was provided."
  value       = "${local.copy_disk}"
}

output "copy_image" {
  description = "Says that a image_resource_id was provided."
  value       = "${local.copy_image}"
}

output "create_empty" {
  description = "Says that a new empty disk will be created."
  value       = "${local.create_empty}"
}

output "create_option" {
  description = "Tells the create option for the managed disk resource."
  value       = "${local.create_option}"
}

output "disk_size_gb" {
  description = "Tells the disk_size_gb provided by input."
  value       = "${var.disk_size_gb}"
}
