variable "managed_disk_name" {
  description = "Name of the new managed disk."
  default     = "myManagedDisk01"
}

variable "resource_group_name" {
  description = "Name of resource group that the managed disk will be created in."
  default     = "myapp-rg"
}

variable "location" {
  description = "The location/region where the managed disk will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions."
  default     = ""
}

variable "source_uri" {
  description = "URI of a VHD to be imported, resulting in a new managed disk. source_uri, source_resource_id, and image_reference_id are mutually exclusive. Leave them all blank to create a new empty managed disk."
  default     = ""
}

variable "source_resource_id" {
  description = "ID of an existing managed disk to copy, resulting in a new managed disk. source_uri, source_resource_id, and image_reference_id are mutually exclusive. Leave them all blank to create a new empty managed disk."
  default     = ""
}

variable "image_reference_id" {
  description = "ID of a platform image to copy, resulting in a new managed disk. source_uri, source_resource_id, and image_reference_id are mutually exclusive. Leave them all blank to create a new empty managed disk."
  default     = ""
}

variable "import_or_copy_os_type" {
  description = "If new managed disk is imported or copied, the os type contained in the source object. May be 'Linux' or 'Windows'"
  default     = ""
}

variable "storage_account_type" {
  description = "Type of storage to use for new managed disk. May be 'Standard_LRS' or 'Premium_LRS'."
  default     = "Premium_LRS"
}

variable "disk_size_gb" {
  description = "For a new empty disk, size of the disk in gb. For a disk copy or a platform image, if provided must be >= the size of the source. Providing a 0 means disk size remains the same as the source."
  default     = 0
}

variable "tags" {
  description = "The tags to associate with your managed disk."
  type        = "map"

  default = {
    tag1 = ""
    tag2 = ""
  }
}
