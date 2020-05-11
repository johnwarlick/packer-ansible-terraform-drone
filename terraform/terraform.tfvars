azure_resource_groups = {
    image =  { 
      name = "test-image-rg" 
      location = "North Central US"
    },
    vm = {
      name = "test-vm-rg"
      location = "South Central US"
    }

}
azure_vnet_name = "test-vm-deploy-vnet"
azure_vnet_cidr = "10.1.0.0/16"
azure_subnet_names = ["test-vm-deploy-subnet1"]
azure_subnet_cidrs = ["10.1.0.0/24"]
azure_nic_name = "public"
azure_image_name = "test-custom-image-base"
vm_count = 1
vm_name = "test-vm"
vm_size = "Standard_B1ls"
vm_admin_user = "testadmin"
public_key_path = "../.ssh/key.pub"
private_key_path = "../.ssh/key"
tags = {
    Environment = "Dev"
    Hello = "Dolly"
}