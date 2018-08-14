output "empty_disk_id" {
  description = "The id of the newly created managed disk"
  value       = "${module.emptyDisk.managed_disk_id}"
}
