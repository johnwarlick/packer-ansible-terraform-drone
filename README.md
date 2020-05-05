# packer-ansible-terraform-drone
Experimenting with simple dummy infrastructure to explore using a Drone.io pipeline for Packer-Ansible for image bake, Terraform for provisioning, and Ansible for post-provision config

# 1. Create Resource Groups
```shell
terraform apply -target=azurerm_resource_group.rg
```

# 2. Bake image
```shell
packer build -var-file=secrets.json ubuntu-base.json
```

# 3. Provision
```shell
terraform apply
```

