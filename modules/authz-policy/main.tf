/**
 * Copyright 2026 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "google_network_security_authz_policy" "authz_policy" {
  project        = var.project_id
  name           = var.name
  location       = var.location
  action         = var.action
  policy_profile = var.policy_profile
  description    = var.description
  labels         = var.labels

  target {
    load_balancing_scheme = var.target.load_balancing_scheme
    resources             = var.target.resources
  }

  dynamic "custom_provider" {
    for_each = var.custom_provider != null ? [var.custom_provider] : []
    content {
      dynamic "authz_extension" {
        for_each = custom_provider.value.authz_extension != null ? [custom_provider.value.authz_extension] : []
        content {
          resources = authz_extension.value.resources
        }
      }
      dynamic "cloud_iap" {
        for_each = custom_provider.value.cloud_iap != null ? [custom_provider.value.cloud_iap] : []
        content {
          enabled = cloud_iap.value.enabled
        }
      }
    }
  }

  dynamic "http_rules" {
    for_each = var.http_rules
    content {
      when = http_rules.value.when

      dynamic "from" {
        for_each = http_rules.value.from != null ? [http_rules.value.from] : []
        content {
          dynamic "sources" {
            for_each = from.value.sources != null ? [from.value.sources] : []
            content {
              dynamic "principals" {
                for_each = sources.value.principals
                content {
                  principal_selector = principals.value.selector
                  principal {
                    exact       = principals.value.exact
                    prefix      = principals.value.prefix
                    suffix      = principals.value.suffix
                    contains    = principals.value.contains
                    ignore_case = principals.value.ignore_case
                  }
                }
              }
              dynamic "ip_blocks" {
                for_each = sources.value.ip_blocks
                content {
                  prefix = split("/", ip_blocks.value)[0]
                  length = tonumber(split("/", ip_blocks.value)[1])
                }
              }
              dynamic "resources" {
                for_each = sources.value.resources != null ? sources.value.resources : []
                content {
                  dynamic "tag_value_id_set" {
                    for_each = resources.value.tag_value_id_set != null ? [resources.value.tag_value_id_set] : []
                    content {
                      ids = tag_value_id_set.value
                    }
                  }
                  dynamic "iam_service_account" {
                    for_each = resources.value.iam_service_account != null ? [resources.value.iam_service_account] : []
                    content {
                      exact       = iam_service_account.value.exact
                      prefix      = iam_service_account.value.prefix
                      suffix      = iam_service_account.value.suffix
                      contains    = iam_service_account.value.contains
                      ignore_case = iam_service_account.value.ignore_case
                    }
                  }
                }
              }
            }
          }

          dynamic "not_sources" {
            for_each = from.value.not_sources != null ? [from.value.not_sources] : []
            content {
              dynamic "principals" {
                for_each = not_sources.value.principals
                content {
                  principal_selector = principals.value.selector
                  principal {
                    exact       = principals.value.exact
                    ignore_case = principals.value.ignore_case
                  }
                }
              }
              dynamic "ip_blocks" {
                for_each = not_sources.value.ip_blocks
                content {
                  prefix = split("/", ip_blocks.value)[0]
                  length = tonumber(split("/", ip_blocks.value)[1])
                }
              }
              dynamic "resources" {
                for_each = not_sources.value.resources != null ? not_sources.value.resources : []
                content {
                  dynamic "tag_value_id_set" {
                    for_each = resources.value.tag_value_id_set != null ? [resources.value.tag_value_id_set] : []
                    content {
                      ids = tag_value_id_set.value
                    }
                  }
                  dynamic "iam_service_account" {
                    for_each = resources.value.iam_service_account != null ? [resources.value.iam_service_account] : []
                    content {
                      exact       = iam_service_account.value.exact
                      prefix      = iam_service_account.value.prefix
                      suffix      = iam_service_account.value.suffix
                      contains    = iam_service_account.value.contains
                      ignore_case = iam_service_account.value.ignore_case
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "to" {
        for_each = http_rules.value.to != null ? [http_rules.value.to] : []
        content {
          dynamic "operations" {
            for_each = to.value.operations != null ? [to.value.operations] : []
            content {
              methods = try(operations.value.methods, null) != null ? operations.value.methods : null

              dynamic "paths" {
                for_each = operations.value.paths != null ? operations.value.paths : []
                content {
                  exact       = paths.value.exact
                  prefix      = paths.value.prefix
                  suffix      = paths.value.suffix
                  contains    = paths.value.contains
                  ignore_case = paths.value.ignore_case
                }
              }

              dynamic "hosts" {
                for_each = operations.value.hosts
                content {
                  exact       = hosts.value.exact
                  prefix      = hosts.value.prefix
                  suffix      = hosts.value.suffix
                  contains    = hosts.value.contains
                  ignore_case = hosts.value.ignore_case
                }
              }

              dynamic "mcp" {
                for_each = operations.value.mcp != null ? [operations.value.mcp] : []
                content {
                  base_protocol_methods_option = mcp.value.base_protocol_methods_option
                  dynamic "methods" {
                    for_each = mcp.value.methods
                    content {
                      name = methods.value.name
                      dynamic "params" {
                        for_each = methods.value.params != null ? [methods.value.params] : []
                        content {
                          exact = params.value
                        }
                      }
                    }
                  }
                }
              }

              dynamic "header_set" {
                for_each = try(operations.value.headers, null) != null ? [1] : []
                content {
                  dynamic "headers" {
                    for_each = operations.value.headers
                    content {
                      name = headers.value.name
                      # Note: 'value' should also be dynamic to avoid empty value {} blocks
                      dynamic "value" {
                        for_each = [1] 
                        content {
                          exact       = try(headers.value.exact, null)
                          prefix      = try(headers.value.prefix, null)
                          suffix      = try(headers.value.suffix, null)
                          contains    = try(headers.value.contains, null)
                          ignore_case = try(headers.value.ignore_case, null)
                        }
                      }
                    }
                  }
                }
              }

            }
          }

          dynamic "not_operations" {
            for_each = to.value.not_operations != null ? [to.value.not_operations] : []
            content {
              methods = not_operations.value.methods
              dynamic "paths" {
                for_each = not_operations.value.paths != null ? not_operations.value.paths : []
                content {
                  exact       = paths.value.exact
                  prefix      = paths.value.prefix
                  suffix      = paths.value.suffix
                  contains    = paths.value.contains
                  ignore_case = paths.value.ignore_case
                }
              }
              dynamic "hosts" {
                for_each = not_operations.value.hosts
                content {
                  exact = hosts.value.exact
                }
              }
            }
          }
        }
      }
    }
  }
  depends_on = [var.module_depends_on]
}
