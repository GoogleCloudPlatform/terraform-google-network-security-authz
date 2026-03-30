/**
 * Copyright 2026 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * ...
 */

variable "project_id" {
  description = "The project ID in which the Authorization Policy will be created. If not provided, the provider project is used."
  type        = string
}

variable "name" {
  description = "The name of the Authorization Policy. If not provided, a random name will be generated."
  type        = string
}

variable "location" {
  description = "The location of the authorization policy. Can be 'global' or a region."
  type        = string
}

variable "action" {
  description = "The action to take when a rule match is found. Possible values are 'ALLOW' or 'DENY'."
  type        = string
}

variable "target" {
  description = "The target resources and load balancing scheme this policy applies to."
  type = object({
    load_balancing_scheme = optional(string)
    resources             = list(string)
  })
}

variable "description" {
  description = "A free-text description of the Authorization Policy."
  type        = string
  default     = null
}

variable "labels" {
  description = "A map of labels to attach to the Authorization Policy."
  type        = map(string)
  default     = {}
}

variable "custom_provider" {
  description = "Required if action is CUSTOM. Configuration for Authz Extension or Cloud IAP."
  type = object({
    authz_extension = optional(object({
      resources = list(string)
    }))
    cloud_iap = optional(object({
      enabled = bool
    }))
  })
  default = null
}

variable "policy_profile" {
  description = "Defines the type of authorization (REQUEST_AUTHZ or CONTENT_AUTHZ)."
  type        = string
  default     = null
}

variable "http_rules" {
  description = "Complete nested structure for Authz Policy HTTP Rules."
  type = list(object({
    when = optional(string)
    from = optional(object({
      sources = optional(object({
        ip_blocks = optional(list(string), [])
        principals = optional(list(object({
          selector    = optional(string, "CLIENT_CERT_URI_SAN")
          exact       = optional(string)
          prefix      = optional(string)
          suffix      = optional(string)
          contains    = optional(string)
          ignore_case = optional(bool, false)
        })), [])
        resources = optional(list(object({
          tag_value_id_set = optional(list(string))
          iam_service_account = optional(object({
            exact       = optional(string)
            prefix      = optional(string)
            suffix      = optional(string)
            contains    = optional(string)
            ignore_case = optional(bool, false)
          }))
        })), [])
      }))
      not_sources = optional(object({
        ip_blocks = optional(list(string), [])
        principals = optional(list(object({
          selector    = optional(string, "CLIENT_CERT_URI_SAN")
          exact       = optional(string)
          ignore_case = optional(bool, false)
        })), [])
        resources = optional(list(object({
          tag_value_id_set = optional(list(string))
          iam_service_account = optional(object({
            exact       = optional(string)
            prefix      = optional(string)
            suffix      = optional(string)
            contains    = optional(string)
            ignore_case = optional(bool, false)
          }))
        })), [])
      }))
    }))
    to = optional(object({
      operations = optional(object({
        methods = optional(list(string), [])
        paths = optional(list(object({
          exact       = optional(string)
          prefix      = optional(string)
          suffix      = optional(string)
          contains    = optional(string)
          ignore_case = optional(bool, false)
        })), [])
        hosts = optional(list(object({
          exact       = optional(string)
          prefix      = optional(string)
          suffix      = optional(string)
          contains    = optional(string)
          ignore_case = optional(bool, false)
        })), [])
        headers = optional(list(object({
          name        = string
          exact       = optional(string)
          prefix      = optional(string)
          suffix      = optional(string)
          contains    = optional(string)
          ignore_case = optional(bool, false)
        })), [])
        mcp = optional(object({
          base_protocol_methods_option = optional(string)
          methods = list(object({
            name   = string
            params = optional(string)
          }))
        }))
      }))
      not_operations = optional(object({
        methods = optional(list(string), [])
        paths = optional(list(object({
          exact       = optional(string)
          prefix      = optional(string)
          suffix      = optional(string)
          contains    = optional(string)
          ignore_case = optional(bool, false)
        })), [])
        hosts = optional(list(object({
          exact = string
        })), [])
      }))
    }))
  }))
  default = []
}
