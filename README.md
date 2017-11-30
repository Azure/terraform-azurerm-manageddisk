# terraform-azurerm-manageddisk #
[![Build Status](https://travis-ci.org/Azure/terraform-azurerm-manageddisk.svg?branch=master)](https://travis-ci.org/Azure/terraform-azurerm-manageddisk)


Deploys 1 Un-Encrypted Managed Disk
===================================

This Terraform module deploys a managed disk in Azure according to one of four available scenarios. Which scenario applies depends on the parameters that you provide.

1. Copy an existing VHD  
   This can be either a specialized OS disk image or a data disk. The scenario is selected by providing source_uri.

2. Copy an existing managed disk  
    The scenario is selected by providing source_resource_id.

3. Import an existing image - a generalized OS disk image  
    This scenario is selected by providing image_reference_id.

4. Empty disk  
   This is the default scenario. It is selected by providing none of the above.  



## Here are examples of the four scenarios:

Scenario 1: Empty Disk
----------------------

```hcl
resource "azurerm_resource_group" "diskRg" {
  name     = "managedDiskRg"
  location = "west us"
}

module "emptyDisk" {

    # required - change to filespec if testing locally, e.g. "./terraform-azurerm-manageddisk"
    source               = "Azure/manageddisk/azurerm"

    # optional - but unless overridden all disks will have the same name
    managed_disk_name    = "myEmptyManagedDisk"

    # required
    resource_group_name  = "${azurerm_resource_group.diskRg.name}"

    # required for a new empty disk
    disk_size_gb         = 1

    # optional - defaults to location of resource group if not provided
    location             = "west us"

    # optional - defaults to Premium_LRS. These are the only two options.
    storage_account_type = "Standard_LRS"
}

output "empty_disk_id" {
  description = "The id of the newly created managed disk"  
  value = "${module.emptyDisk.managed_disk_id}"
}
```

Scenario 2: Copy a VHD
----------------------

```hcl
module "copyVHD" {
    source               = "Azure/manageddisk/azurerm"
    managed_disk_name    = "myVHDCopy"
    resource_group_name  = "${azurerm_resource_group.diskRg.name}"

    # required - if provided instructs the module to copy the VHD
    source_uri           = "https://00mq7xv.blob.core.windows.net/vhds/my.vhd"

    # optional for a copy. Defaults to the size of the source if not provided. If provided must be >= size of source.
    disk_size_gb         = xx
}
```

Scenario 3: Copy an Existing Managed Disk
-----------------------------------------

```hcl
module "copyDisk" {
    source               = "./terraform-azurerm-manageddisk"
    managed_disk_name    = "myExistingDiskCopy"
    resource_group_name  = "${azurerm_resource_group.diskRg.name}"
 
    # required - if provided instructs the module to copy the managed disk
    source_resource_id   = "/subscriptions/myAzureSubscriptionID/resourceGroups/myResourceGroupName/providers/Microsoft.Compute/disks/nameOfDisk"

    # optional
    disk_size_gb         = xx
}
```

Scenario 4: Copy an Image
-----------------------------------------

In this case, a platform image.

```hcl
data "azurerm_platform_image" "ubuntu1604" {
  location  = "${azurerm_resource_group.diskRg.location}"
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "16.04-LTS"
}

module "fromImage" {
    source               = "./terraform-azurerm-manageddisk"
    managed_disk_name    = "myPlatformImageDisk"
    resource_group_name  = "${azurerm_resource_group.diskRg.name}"

    # required - if provided instructs the module to copy the image
    image_reference_id   = "${data.azurerm_platform_image.ubuntu1604.id}"
}
```

Authors
=======
Originally created by [Greg Oliver](http://github.com/sebastus)

License
=======

[MIT](LICENSE)

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
