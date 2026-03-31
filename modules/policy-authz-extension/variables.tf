/**
 * Copyright 2026 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * ...
 */

variable "project_id" {
  type        = string
  description = "The ID of the project in which the resource belongs."
}

variable "location" {
  type        = string
  description = "The GCP region to deploy the resources."
}

variable "extensions_config" {
  description = "A map of unique Authz Extensions, indexed by their name."
  type = map(object({
    backend_service       = string
    authority             = optional(string)
    load_balancing_scheme = optional(string)
    description           = optional(string, "Managed by ADC")
    timeout               = optional(string, "0.1s")
    fail_open             = optional(bool, false)
    forward_headers       = optional(list(string), [])
  }))
}

variable "policies_config" {
  description = "A map of Authz Policies with structured HTTP rules, indexed by name."
  type = map(object({
    action                = string
    load_balancing_scheme = string
    target_resources      = optional(list(string), [])
    description           = optional(string, "Managed by ADC")
    extension_names       = optional(list(string), [])
    iap_enabled           = optional(bool, false)
    http_rules = optional(list(object({
      when = optional(string)
      from = optional(object({
        not_sources = optional(list(object({
          ip_blocks = optional(list(object({
            prefix = string
            length = number
          })), [])
          principals = optional(list(object({
            principal_selector = optional(string, "CLIENT_CERT_URI_SAN")
            principal = optional(object({
              exact       = optional(string)
              ignore_case = optional(bool, true)
            }))
          })), [])
        })), [])
      }))
      to = optional(object({
        operations = optional(list(object({
          methods = optional(list(string), [])
          paths   = optional(list(object({ exact = string })), [])
          header_set = optional(list(object({
            headers = optional(list(object({
              name = string
              value = optional(object({
                exact       = string
                ignore_case = optional(bool, true)
              }))
            })), [])
          })), [])
        })), [])
      }))
    })), [])
  }))
}
