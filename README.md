# terraform-azurerm-manageddisk

[![Build Status](https://travis-ci.org/Azure/terraform-azurerm-manageddisk.svg?branch=master)](https://travis-ci.org/Azure/terraform-azurerm-manageddisk)

## Deploys 1 Un-Encrypted Managed Disk

This Terraform module deploys a managed disk ([overview here](https://azure.microsoft.com/en-us/services/managed-disks/)) in Azure according to one of four available scenarios. Which scenario applies depends on the parameters that you provide.

1. Empty disk  
   This is the default scenario. It is selected by providing none of ```source_uri```, ```source_resource_id``` or ```image_reference_id```. It will also be selected if more than one of them is provided.  

1. Copy an existing VHD  
   This can be either a specialized OS disk image or a data disk. The scenario is selected by providing ```source_uri```.

1. Copy an existing managed disk  
    The scenario is selected by providing ```source_resource_id```.

1. Import an existing image - a generalized OS disk image  
    This scenario is selected by providing ```image_reference_id```.  

The size of the new managed disk must be specified for an empty disk. The available sizes are documented [here](https://azure.microsoft.com/en-us/pricing/details/managed-disks/). For other scenarios, specifying the size can resize the disk larger, but not smaller than the source.

## Here are examples of the four scenarios

### Scenario 1: Empty Disk

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

### Scenario 2: Copy a VHD

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

### Scenario 3: Copy an Existing Managed Disk

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

### Scenario 4: Copy an Image

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

## Test

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We provide 2 ways to build, run, and test the module on a local development machine. [Native (Mac/Linux)](#native-maclinux) or [Docker](#docker).

### Native(Mac/Linux)

#### Prerequisites

- [Ruby **(~> 2.3)**](https://www.ruby-lang.org/en/downloads/)
- [Bundler **(~> 1.15)**](https://bundler.io/)
- [Terraform **(~> 0.11.7)**](https://www.terraform.io/downloads.html)
- [Golang **(~> 1.10.3)**](https://golang.org/dl/)

#### Environment setup

We provide simple script to quickly set up module development environment:

```sh
$ curl -sSL https://raw.githubusercontent.com/Azure/terramodtest/master/tool/env_setup.sh | sudo bash
```

#### Run test

Then simply run it in local shell:

```sh
$ cd $GOPATH/src/{directory_name}/
$ bundle install
$ rake build
$ rake e2e
```

### Docker

We provide a Dockerfile to build a new image based `FROM` the `microsoft/terraform-test` Docker hub image which adds additional tools / packages specific for this module (see Custom Image section).  Alternatively use only the `microsoft/terraform-test` Docker hub image [by using these instructions](https://github.com/Azure/terraform-test).

#### Prerequisites

- [Docker](https://www.docker.com/community-edition#/download)

#### Custom Image

This builds the custom image:

```sh
$ docker build --build-arg BUILD_ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID --build-arg BUILD_ARM_CLIENT_ID=$ARM_CLIENT_ID --build-arg BUILD_ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET --build-arg BUILD_ARM_TENANT_ID=$ARM_TENANT_ID -t azure-manageddisk .
```

This runs the build and unit tests:

```sh
$ docker run --rm azure-manageddisk /bin/bash -c "bundle install && rake build"
```

This runs the end to end tests:

```sh
$ docker run --rm azure-manageddisk /bin/bash -c "bundle install && rake e2e"
```

This runs the full tests:

```sh
$ docker run --rm azure-manageddisk /bin/bash -c "bundle install && rake full"
```

## Authors

Originally created by [Greg Oliver](http://github.com/sebastus)

## License

[MIT](LICENSE)

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit [https://cla.microsoft.com](https://cla.microsoft.com).

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
