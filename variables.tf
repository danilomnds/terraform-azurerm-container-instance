variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "Standard"
}

variable "identity" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Container Registry"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "init_container" {
  type = object({
    name                         = string
    image                        = string
    environment_variables        = optional(map(string))
    secure_environment_variables = optional(map(string))
    commands                     = optional(list(string))
    volume = optional(object({
      name                 = string
      mount_path           = string
      read_only            = optional(bool)
      empty_dir            = optional(bool)
      storage_account_name = optional(string)
      storage_account_key  = optional(string)
      share_name           = optional(string)
      git_repo = optional(object({
        url       = string
        directory = optional(string)
        revision  = optional(string)
      }))
    }))
    security = optional(object({
      privilege_enabled = bool
    }))
  })
  default = null
}

variable "container" {
  type = list(object({
    name         = string
    image        = string
    cpu          = string
    memory       = string
    cpu_limit    = optional(string)
    memory_limit = optional(string)
    ports = optional(object({
      port     = optional(number)
      protocol = optional(string)
    }))
    environment_variables        = optional(map(string))
    secure_environment_variables = optional(map(string))
    readiness_probe = optional(object({
      exec = optional(list(string))
      http_get = optional(object({
        path         = optional(string)
        port         = optional(number)
        scheme       = optional(number)
        http_headers = optional(map(string))
      }))
      initial_delay_seconds = optional(number)
      period_seconds        = optional(number)
      failure_threshold     = optional(number)
      success_threshold     = optional(number)
      timeout_seconds       = optional(number)
    }))
    liveness_probe = optional(object({
      exec = optional(list(string))
      http_get = optional(object({
        path         = optional(string)
        port         = optional(number)
        scheme       = optional(number)
        http_headers = optional(map(string))
      }))
      initial_delay_seconds = optional(number)
      period_seconds        = optional(number)
      failure_threshold     = optional(number)
      success_threshold     = optional(number)
      timeout_seconds       = optional(number)
    }))
    commands = optional(list(string))
    volume = optional(object({
      name                 = string
      mount_path           = string
      read_only            = optional(bool)
      empty_dir            = optional(bool)
      storage_account_name = optional(string)
      storage_account_key  = optional(string)
      share_name           = optional(string)
      git_repo = optional(object({
        url       = string
        directory = optional(string)
        revision  = optional(string)
      }))
      secret = optional(map(string))
    }))
    security = optional(object({
      privilege_enabled = bool
    }))
  }))
  default = null
}

variable "os_type" {
  type = string
}

variable "dns_config" {
  type = object({
    nameservers    = list(string)
    search_domains = optional(list(string))
    options        = optional(list(string))
  })
  default = null
}

variable "diagnostics" {
  type = object({
    log_analytics = object({
      log_type      = optional(string)
      workspace_id  = string
      workspace_key = string
      metadata      = optional(map(string))
    })
  })
  default = null
}

variable "dns_name_label" {
  type    = string
  default = null
}

variable "dns_name_label_reuse_policy" {
  type    = string
  default = "Unsecure"
}

variable "exposed_port" {
  type = list(object({
    port     = optional(string)
    protocol = optional(string)
  }))
  default = null
}

variable "ip_address_type" {
  type    = string
  default = "Private"
}

variable "key_vault_key_id" {
  type    = string
  default = null
}

variable "key_vault_user_assigned_identity_id" {
  type    = string
  default = null
}

variable "subnet_ids" {
  type    = list(string)
  default = null
}

variable "image_registry_credential" {
  type = object({
    user_assigned_identity_id = optional(string)
    username                  = optional(string)
    password                  = optional(string)
    server                    = string
  })
  default = null
}

variable "priority" {
  type    = string
  default = null
}

variable "restart_policy" {
  type    = string
  default = "Always"
}

variable "zones" {
  type    = list(string)
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "azure_ad_groups" {
  type    = list(string)
  default = []
}

variable "container_instance_contributor" {
  description = "Allows stop, start and redeploy"
  type        = bool
  default     = true
}

variable "resource_group_reader" {
  description = "Allows the Event Hub owner to get write and delete the keys on eventhub only. "
  type        = bool
  default     = false
}