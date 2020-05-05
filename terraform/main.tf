# See  https://www.terraform.io/docs/providers/azurerm/index.html
provider "azurerm" {
    # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
    version = "=2.0.0"

    client_id= var.azure_client_id
    client_secret = var.azure_client_secret
    tenant_id= var.azure_tenant_id
    subscription_id = var.azure_subscription_id
    features {}
}

resource "azurerm_resource_group" "rg" {
    for_each  = var.azure_resource_groups
    name     = each.value["name"]
    location = each.value["location"]
}

module "azure_network" {
    source              = "Azure/network/azurerm"
    resource_group_name = azurerm_resource_group.rg["vm"].name
    vnet_name           = var.azure_vnet_name
    address_space       = var.azure_vnet_cidr
    subnet_prefixes     = var.azure_subnet_cidrs
    subnet_names        = var.azure_subnet_names

    tags = var.tags
}

resource "azurerm_public_ip" "ip" {
    count                   = var.vm_count
    name                    = join("-", ["public", count.index])
    location                = azurerm_resource_group.rg["vm"].location
    resource_group_name     = azurerm_resource_group.rg["vm"].name
    allocation_method       = "Dynamic"
    idle_timeout_in_minutes = 30
}

resource "azurerm_network_interface" "nic" {
    count = var.vm_count
    name                = join("-", [var.azure_nic_name, count.index])
    location            = azurerm_resource_group.rg["vm"].location
    resource_group_name = azurerm_resource_group.rg["vm"].name

    ip_configuration {
        name                          = format("public-%s", count.index)
        # It is an exercise left up to you to explore how to split these among multiple subnets  
        # We are just passing in the first one here
        subnet_id                     = module.azure_network.vnet_subnets[0]
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = element(azurerm_public_ip.ip.*.id, count.index)
    }
}

# Locate the custom image
data "azurerm_image" "search" {
  name                = var.azure_image_name
  resource_group_name = azurerm_resource_group.rg["image"].name
}

resource "azurerm_linux_virtual_machine" "vms" {
    count               = var.vm_count
    name                = join("-", [var.vm_name, count.index])
    resource_group_name = azurerm_resource_group.rg["vm"].name
    location            = azurerm_resource_group.rg["vm"].location
    admin_username      = var.vm_admin_user
    size                = var.vm_size
    network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]

    admin_ssh_key {
        username   = var.vm_admin_user
        public_key = file(var.public_key_path)
    }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    
    source_image_id = data.azurerm_image.search.id

    # This is to ensure SSH comes up before we run the local exec.
    provisioner "remote-exec" { 
        inline = ["echo 'Hello World'"]

        connection {
            type = "ssh"
            host = self.public_ip_address
            user = var.vm_admin_user
            private_key = file(var.private_key_path)
        }
    }

    provisioner "local-exec" {
        command = "ansible-playbook -e 'ansible_user=${var.vm_admin_user}' -i ${self.public_ip_address}, --private-key ${var.private_key_path} --ssh-common-args='-o StrictHostKeyChecking=no' ../ansible/vm-configure.yml"
    }

}
