# Module - Azure Container Instances
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()
[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

Module developed to standardize the Container Instance creation.

## Compatibility Matrix

| Module Version | Terraform Version | AzureRM Version |
|----------------|-------------------| --------------- |
| v1.0.0         | v1.10.5           | 4.16.0           |

## Specifying a version

To avoid that your code get updates automatically, is mandatory to set the version using the `source` option. 
By defining the `?ref=***` in the the URL, you can define the version of the module.

Note: The `?ref=***` refers a tag on the git module repo.

## Default use case

```hcl
module "<ci-system-env-description-id>" {
  source = "git::https://github.com/danilomnds/terraform-azurerm-container-instance?ref=v1.0.0"
  name = "ci-system-env-description-id"
  location = "<location>"
  resource_group_name  = "<resource-group-name>"
  # case sensitive. Valid options are "Linux" or "Windows"
  os_type = "Linux"
  sku = "<Confidential/Dedicated/Standard"  
  container = [
    {
      name   = "hello-world"
      image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
      cpu    = "0.5"
      memory = "1.5"
      ports = {
        port     = 443
        protocol = "TCP"
      }
    },
    {
      name   = "sidecar"
      image  = "mcr.microsoft.com/azuredocs/aci-tutorial-sidecar"
      cpu    = "0.5"
      memory = "1.5"
    }
  ]
  subnet_ids = ["subnet id"]
  azure_ad_groups = ["group id 1"]
  resource_group_reader = true
  tags = {
    key = value
    key2 = value
  } 
}
output "id" {
  value = module.<ci-system-env-description-id>.id
}
```

## Input variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Specifies the name of the Container Group | `string` | n/a | `Yes` |
| location | Specifies the supported Azure location where the resource exists | `string` | n/a | `Yes` |
| resource_group_name | The name of the resource group in which to create the Container Group | `string` | n/a | `Yes` |
| sku | Specifies the sku of the Container Group | `string` | `Standard` | `Yes` |
| identity | block as defined [here] (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group)| `object()` | n/a | No |
| init_container | The definition of an init container that is part of the group as documented in the init_container block as defined [here] (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group)| `object()` | n/a | No |
| container | The definition of a container that is part of the group as documented in the container block as defined [here] (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group). You specify more than one. | `list(object())` | n/a | `Yes` |
| os_type | The OS for the container group. Allowed values are Linux and Windows | `string` | n/a | `Yes` |
| dns_config | A dns_config block as documented [here] (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group)| `object()` | n/a | No |
| diagnostics | A diagnostics  block as documented [here] (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group)| `object()` | n/a | No |
| dns_name_label | The DNS label/name for the container group's IP | `string` | n/a | No |
| dns_name_label_reuse_policy | The value representing the security enum | `string` | `Unsecure` | No |
| exposed_port | Zero or more exposed_port blocks as defined [here] (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group)| `list(object())` | n/a | No |
| ip_address_type | Specifies the IP address type of the container | `string` | `Private` | No |
| key_vault_key_id | The Key Vault key URI for CMK encryption. Changing this forces a new resource to be created | `string` | n/a | No |
| key_vault_user_assigned_identity_id | The user assigned identity that has access to the Key Vault Key | `string` | n/a | No |
| subnet_ids | The subnet resource IDs for a container group | `list(string)` | n/a | No |
| image_registry_credential | An image_registry_credential block as documented [here] (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group)| `object()` | n/a | No |
| priority | The priority of the Container Group | `string` | n/a | No |
| restart_policy | Restart policy for the container group | `string` | `Always` | No |
| zones | A list of Availability Zones in which this Container Group is located | `list(string)` | n/a | No |
| tags | tags for the resource | `map(string)` | `{}` | No |
| azure_ad_groups | list of azure AD groups that will be granted the Reader role  | `list` | `[]` | No |
| container_instance_contributor | grantees container instance contributor custom role | `bool` | `true` | No |
| resource_group_reader | reader access on container instance resource group | `bool` | `false` | No |

## Output variables

| Name | Description |
|------|-------------|
| id | container instance id |

## Documentation

Terraform Container Group (instance): <br>
[https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group)<br>