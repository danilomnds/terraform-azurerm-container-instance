resource "azurerm_container_group" "instance" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
  dynamic "init_container" {
    for_each = var.init_container != null ? [var.init_container] : []
    content {
      name                         = init_container.value.name
      image                        = init_container.value.image
      environment_variables        = lookup(init_container.value, "environment_variables", null)
      secure_environment_variables = lookup(init_container.value, "secure_environment_variables", null)
      commands                     = lookup(init_container.value, "commands", null)
      dynamic "volume" {
        for_each = init_container.value.volume != null ? [init_container.value.volume] : []
        content {
          name                 = volume.value.name
          mount_path           = volume.value.mount_path
          read_only            = lookup(volume.value, "read_only", null)
          empty_dir            = lookup(volume.value, "empty_dir", null)
          storage_account_name = lookup(volume.value, "storage_account_name", null)
          storage_account_key  = lookup(volume.value, "storage_account_key", null)
          share_name           = lookup(volume.value, "share_name", null)
          dynamic "git_repo" {
            for_each = volume.value.git_repo != null ? [volume.value.git_repo] : []
            content {
              url       = git_repo.value.url
              directory = lookup(git_repo.value, "directory", null)
              revision  = lookup(git_repo.value, "revision", null)
            }
          }
        }
      }
      dynamic "security" {
        for_each = init_container.value.security != null ? [init_container.value.security] : []
        content {
          privilege_enabled = security.value.privilege_enabled
        }
      }
    }
  }
  container {
    name         = var.container[0].name
    image        = var.container[0].image
    cpu          = var.container[0].cpu
    memory       = var.container[0].memory
    cpu_limit    = lookup(var.container[0], "cpu_limit", null)
    memory_limit = lookup(var.container[0], "memory_limit", null)
    dynamic "ports" {
      for_each = var.container[0].ports != null ? [var.container[0].ports] : []
      content {
        port     = lookup(ports.value, "port", null)
        protocol = lookup(ports.value, "protocol", "TCP")
      }
    }
    environment_variables        = lookup(var.container[0], "environment_variables", null)
    secure_environment_variables = lookup(var.container[0], "secure_environment_variables", null)
    dynamic "readiness_probe" {
      for_each = var.container[0].readiness_probe != null ? [var.container[0].readiness_probe] : []
      content {
        exec = lookup(readiness_probe.value, "exec", null)
        dynamic "http_get" {
          for_each = readiness_probe.value.http_get != null ? [readiness_probe.value.http_get] : []
          content {
            path         = lookup(http_get.value, "path", null)
            port         = lookup(http_get.value, "port", null)
            http_headers = lookup(http_get.value, "http_headers", null)
            scheme       = lookup(http_get.value, "scheme", null)
          }
        }
        initial_delay_seconds = lookup(readiness_probe.value, "initial_delay_seconds", null)
        period_seconds        = lookup(readiness_probe.value, "period_seconds", null)
        failure_threshold     = lookup(readiness_probe.value, "failure_threshold", null)
        success_threshold     = lookup(readiness_probe.value, "success_threshold", null)
        timeout_seconds       = lookup(readiness_probe.value, "timeout_seconds", null)
      }
    }
    dynamic "liveness_probe" {
      for_each = var.container[0].liveness_probe != null ? [var.container[0].liveness_probe] : []
      content {
        exec = lookup(liveness_probe.value, "exec", null)
        dynamic "http_get" {
          for_each = liveness_probe.value.http_get != null ? [liveness_probe.value.http_get] : []
          content {
            path         = lookup(http_get.value, "path", null)
            port         = lookup(http_get.value, "port", null)
            http_headers = lookup(http_get.value, "http_headers", null)
            scheme       = lookup(http_get.value, "scheme", null)
          }
        }
        initial_delay_seconds = lookup(liveness_probe.value, "initial_delay_seconds", null)
        period_seconds        = lookup(liveness_probe.value, "period_seconds", null)
        failure_threshold     = lookup(liveness_probe.value, "failure_threshold", null)
        success_threshold     = lookup(liveness_probe.value, "success_threshold", null)
        timeout_seconds       = lookup(liveness_probe.value, "timeout_seconds", null)
      }
    }
    commands = lookup(var.container[0], "commands", null)
    dynamic "volume" {
      for_each = var.container[0].volume != null ? [var.container[0].volume] : []
      content {
        name                 = volume.value.name
        mount_path           = volume.value.mount_path
        read_only            = lookup(volume.value, "read_only", false)
        empty_dir            = lookup(volume.value, "empty_dir", false)
        storage_account_key  = lookup(volume.value, "storage_account_key", null)
        storage_account_name = lookup(volume.value, "storage_account_name", null)
        share_name           = lookup(volume.value, "share_name", null)
        dynamic "git_repo" {
          for_each = volume.value.git_repo != null ? [volume.value.git_repo] : []
          content {
            url       = git_repo.value.url
            directory = lookup(git_repo.value, "directory", null)
            revision  = lookup(git_repo.value, "revision", null)
          }
        }
        secret = lookup(volume.value, "secret", null)
      }
    }
    dynamic "security" {
      for_each = var.container[0].security != null ? [var.container[0].security] : []
      content {
        privilege_enabled = security.value.privilege_enabled
      }
    }
  }
  dynamic "container" {
    for_each = length(var.container) > 1 ? slice(var.container, 1, length(var.container)) : []
    content {
      name         = var.container.name
      image        = var.container.image
      cpu          = var.container.cpu
      memory       = var.container.memory
      cpu_limit    = lookup(var.container, "cpu_limit", null)
      memory_limit = lookup(var.container, "memory_limit", null)
      dynamic "ports" {
        for_each = length(var.container) > 1 ? [] : container.ports
        content {
          port     = lookup(ports.value, "port", null)
          protocol = lookup(ports.value, "protocol", "TCP")
        }
      }
      environment_variables        = lookup(var.container, "environment_variables", null)
      secure_environment_variables = lookup(var.container, "secure_environment_variables", null)
      dynamic "readiness_probe" {
        for_each = length(var.container) > 1 ? [] : container.readiness_probe
        content {
          exec = lookup(readiness_probe.value, "exec", null)
          dynamic "http_get" {
            for_each = readiness_probe.value.http_get != null ? [readiness_probe.value.http_get] : []
            content {
              path         = lookup(http_get.value, "path", null)
              port         = lookup(http_get.value, "port", null)
              http_headers = lookup(http_get.value, "http_headers", null)
              scheme       = lookup(http_get.value, "scheme", null)
            }
          }
          initial_delay_seconds = lookup(readiness_probe.value, "initial_delay_seconds", null)
          period_seconds        = lookup(readiness_probe.value, "period_seconds", null)
          failure_threshold     = lookup(readiness_probe.value, "failure_threshold", null)
          success_threshold     = lookup(readiness_probe.value, "success_threshold", null)
          timeout_seconds       = lookup(readiness_probe.value, "timeout_seconds", null)
        }
      }
      dynamic "liveness_probe" {
        for_each = length(var.container) > 1 ? [] : container.liveness_probe
        content {
          exec = lookup(liveness_probe.value, "exec", null)
          dynamic "http_get" {
            for_each = liveness_probe.value.http_get != null ? [liveness_probe.value.http_get] : []
            content {
              path         = lookup(http_get.value, "path", null)
              port         = lookup(http_get.value, "port", null)
              http_headers = lookup(http_get.value, "http_headers", null)
              scheme       = lookup(http_get.value, "scheme", null)
            }
          }
          initial_delay_seconds = lookup(liveness_probe.value, "initial_delay_seconds", null)
          period_seconds        = lookup(liveness_probe.value, "period_seconds", null)
          failure_threshold     = lookup(liveness_probe.value, "failure_threshold", null)
          success_threshold     = lookup(liveness_probe.value, "success_threshold", null)
          timeout_seconds       = lookup(liveness_probe.value, "timeout_seconds", null)
        }
      }
      commands = lookup(var.container, "commands", null)
      dynamic "volume" {
        for_each = length(var.container) > 1 ? [] : container.volume
        content {
          name                 = volume.value.name
          mount_path           = volume.value.mount_path
          read_only            = lookup(volume.value, "read_only", false)
          empty_dir            = lookup(volume.value, "empty_dir", false)
          storage_account_key  = lookup(volume.value, "storage_account_key", null)
          storage_account_name = lookup(volume.value, "storage_account_name", null)
          share_name           = lookup(volume.value, "share_name", null)
          dynamic "git_repo" {
            for_each = volume.value.git_repo != null ? [volume.value.git_repo] : []
            content {
              url       = git_repo.value.url
              directory = lookup(git_repo.value, "directory", null)
              revision  = lookup(git_repo.value, "revision", null)
            }
          }
          secret = lookup(volume.value, "secret", null)
        }
      }
      dynamic "security" {
        for_each = length(var.container) > 1 ? [] : container.security
        content {
          privilege_enabled = security.value.privilege_enabled
        }
      }
    }
  }
  os_type = var.os_type
  dynamic "dns_config" {
    for_each = var.dns_config != null ? [var.dns_config] : []
    content {
      nameservers    = dns_config.value.nameservers
      search_domains = lookup(dns_config.value, "search_domains", null)
      options        = lookup(dns_config.value, "options", null)
    }
  }
  dynamic "diagnostics" {
    for_each = var.diagnostics != null ? [var.diagnostics] : []
    content {
      dynamic "log_analytics" {
        for_each = diagnostics.value.log_analytics != null ? [diagnostics.value.log_analytics] : []
        content {
          log_type      = lookup(log_analytics.value, "log_type", null)
          workspace_id  = log_analytics.value.workspace_id
          workspace_key = log_analytics.value.workspace_key
          metadata      = lookup(log_analytics.value, "metadata", null)
        }
      }
    }
  }
  dns_name_label              = var.dns_name_label
  dns_name_label_reuse_policy = var.dns_name_label_reuse_policy
  dynamic "exposed_port" {
    for_each = var.exposed_port != null ? var.exposed_port : []
    content {
      port     = lookup(exposed_port.value, "port", null)
      protocol = lookup(exposed_port.value, "protocol", null)
    }
  }
  ip_address_type                     = var.ip_address_type
  key_vault_key_id                    = var.key_vault_key_id
  key_vault_user_assigned_identity_id = var.key_vault_user_assigned_identity_id
  subnet_ids                          = var.subnet_ids
  dynamic "image_registry_credential" {
    for_each = var.image_registry_credential != null ? [var.image_registry_credential] : []
    content {
      user_assigned_identity_id = lookup(image_registry_credential.value, "user_assigned_identity_id", null)
      username                  = lookup(image_registry_credential.value, "username", null)
      password                  = lookup(image_registry_credential.value, "password", null)
      server                    = user_assigned_identity_id.value.server
    }
  }
  priority       = var.priority
  restart_policy = var.restart_policy
  zones          = var.zones
  tags           = local.tags
  lifecycle {
    ignore_changes = [
      tags["create_date"]
    ]
  }
}

resource "azurerm_role_assignment" "rg_reader" {
  depends_on = [
    azurerm_container_group.instance
  ]
  for_each = {
    for group in var.azure_ad_groups : group => group
    if var.resource_group_reader && var.azure_ad_groups != []
  }
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "container_instance_contributor" {
  depends_on = [
    azurerm_container_group.instance
  ]
  for_each = {
    for group in var.azure_ad_groups : group => group
    if var.container_instance_contributor && var.azure_ad_groups != []
  }
  scope                = azurerm_container_group.instance.id
  role_definition_name = "Azure Container Instances Contributor Role Custom"
  principal_id         = each.value
}