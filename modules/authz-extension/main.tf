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

resource "google_network_services_authz_extension" "this" {
  project               = var.project_id
  name                  = var.name
  location              = var.location
  authority             = var.authority
  description           = var.description
  labels                = var.labels
  load_balancing_scheme = var.load_balancing_scheme
  service               = var.service
  timeout               = var.timeout
  fail_open             = var.fail_open
  metadata = merge(
    var.metadata,
    length(var.model_armor_templates) > 0 ? {
      model_armor_settings = jsonencode([
        for template_id in var.model_armor_templates : {
          request_template_id  = template_id
          response_template_id = template_id
        }
      ])
    } : {}
  )
  forward_headers       = var.forward_headers
  wire_format           = var.wire_format
}
