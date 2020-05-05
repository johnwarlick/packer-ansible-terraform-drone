variable "azure_client_id" {}
variable "azure_client_secret" {}
variable "azure_tenant_id" {}
variable "azure_subscription_id" {}

variable "azure_resource_groups" {
  type = map(object({
    name = string
    location = string
  }))
  default = {
    image =  {
      name = "" 
      location = ""
    },
    vm = {
      name = ""
      location = ""
    }
  }
}

variable "azure_resource_group_location" {
  default = "South Central US"
}

variable "azure_vnet_name" {
  default = "test-vm-deploy-vnet"
}

variable "azure_vnet_cidr" {
  description = "The CIDR block for the Vnet"
  default = "10.1.0.0/16"
}

variable "azure_subnet_names" {
  description = "The subnet names"
  type = list
  default = ["test-vm-deploy-subnet1", "test-vm-deploy-subnet2"]
}

variable "azure_subnet_cidrs" {
  description = "The subnet CIDRs that map to azure_subnet_names by list order"
  type = list
  default = ["10.1.0.0/24", "10.2.0.0/24"]
}

variable "azure_nic_name" {
  default = "test-vm-deploy-nic"
}

variable "tags" {
    type = map

    default = {
        Environment = "Dev"
        Foo = "Bar"
  }
}

variable "vm_count" {
  type = number
  default = 1
}

variable "azure_image_name" {
  description = "The custom Image name"
  default = ""
}
variable "azure_image_resource_group" {
  description = "The Resource Group the custom Image is in"
  default = ""
}

variable "azure_image_resource_group_location" {
  description = "The Resource Group location the custom Image is in"
  default = "South Central US"
}

variable "vm_name" {
  default = "test-vm"
}

variable "vm_size" {
  default = "Standard_B1ls"
}

variable "vm_admin_user" {
  description = "Admin user for the VM"
  default = "admin"
}

variable "public_key_path" {
  description = "Public key path"
  default = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Private key path"
  default = "~/.ssh/id_rsa"
}