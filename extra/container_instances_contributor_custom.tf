# Azure Container Instances Contributor Role Custom
resource "azurerm_role_definition" "container_instances_contributor_custom" {
  depends_on = [
    data.azurerm_management_group.management_group
  ]
  name        = "Azure Container Instances Contributor Role Custom"
  scope       = data.azurerm_management_group.management_group.id
  description = "This is a custom role created via Terraform for Container Instances Service"
  permissions {
    actions = [
      "Microsoft.ContainerInstance/*/read",
      "Microsoft.ContainerInstance/containerGroups/restart/action",
      "Microsoft.ContainerInstance/containerGroups/stop/action",
      "Microsoft.ContainerInstance/containerGroups/start/action",
      "Microsoft.ContainerInstance/containerGroups/containers/exec/action",
      "Microsoft.ContainerInstance/containerGroups/containers/attach/action",
      "Microsoft.ContainerInstance/containerScaleSets/containerGroups/restart/action",
      "Microsoft.ContainerInstance/containerScaleSets/containerGroups/start/action",
      "Microsoft.ContainerInstance/containerScaleSets/containerGroups/stop/action",
      "Microsoft.Support/*"
    ]
    not_actions      = []
    data_actions     = []
    not_data_actions = []
  }
  assignable_scopes = [
    data.azurerm_management_group.management_group.id
  ]
}