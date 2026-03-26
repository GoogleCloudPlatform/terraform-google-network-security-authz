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

# 1. Create a dummy health check and backend service for the Authz Extension to reference
resource "google_compute_health_check" "default" {
  name               = "authz-ext-hc"
  project            = var.project_id
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_backend_service" "default" {
  name                  = "authz-ext-backend"
  project               = var.project_id
  health_checks         = [google_compute_health_check.default.id]
  load_balancing_scheme = "INTERNAL_MANAGED"
  protocol              = "HTTP2"
}

# 2. Call your Authz Extension module
module "authz_extension" {
  source = "../../modules/authz-extension"

  project_id            = var.project_id
  name                  = "simple-authz-extension"
  location              = "global"
  service               = google_compute_backend_service.default.self_link
  authority             = "auth.example.com"
  timeout               = "5s"
  load_balancing_scheme = "INTERNAL_MANAGED"
  description           = "Test authz extension"
  labels = {
    environment = "test"
  }
}
