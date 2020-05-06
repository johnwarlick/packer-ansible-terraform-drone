# packer-ansible-terraform-drone
Experimenting with simple dummy infrastructure to explore using a Drone.io pipeline for Packer-Ansible for image bake, Terraform for provisioning, and Ansible for post-provision config

You will need to pass in the terraform cloud team / user token since `drone exec` cannot read secrets from the server. 
```shell
drone exec --secret-file=terraform/secrets.auto.tfvars
```
