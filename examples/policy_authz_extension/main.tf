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

# 1. Override the providers to use the staging endpoints
provider "google" {
  network_security_custom_endpoint    = "https://staging-networksecurity.sandbox.googleapis.com/v1beta1/"
  network_services_custom_endpoint    = "https://staging-networkservices.sandbox.googleapis.com/v1alpha1/"
  certificate_manager_custom_endpoint = "https://staging-certificatemanager.sandbox.googleapis.com/v1/"
}

provider "google-beta" {
  network_security_custom_endpoint    = "https://staging-networksecurity.sandbox.googleapis.com/v1beta1/"
  network_services_custom_endpoint    = "https://staging-networkservices.sandbox.googleapis.com/v1alpha1/"
  certificate_manager_custom_endpoint = "https://staging-certificatemanager.sandbox.googleapis.com/v1beta1/"
}

data "google_project" "project" {
  project_id = var.project_id
}

# 2. Dummy Agent Gateway (Required by the Authz Policy target)
resource "google_network_services_agent_gateway" "default" {
  provider  = google-beta
  name      = "integ-policy-target-ag"
  project   = var.project_id
  location  = "us-central1"
  protocols = ["MCP"]

  google_managed {
    governed_access_path = "AGENT_TO_ANYWHERE"
  }
}

# 3. Call your Integrated Module
module "policy_authz_extension" {
  source = "../../modules/policy-authz-extension"

  project_id = var.project_id
  location   = "us-central1"

  # Define the Extension
  extensions_config = {
    "integrated-ext" = {
      description = "Test integrated extension"
      # FIX: Pass empty string for LB scheme when using an FQDN
      load_balancing_scheme = ""
      authority             = "auth.example.com"

      # FIX: Use an FQDN to completely bypass the Terraform Provider regional bug
      backend_service = "authz.example.com"

      timeout         = "5s"
      fail_open       = false
      forward_headers = []
    }
  }

  # Define the Policy that uses the Extension
  policies_config = {
    "integrated-policy" = {
      description = "Test integrated policy"
      action      = "CUSTOM"

      # Agent Gateways don't use load balancing schemes, so we pass an empty string
      load_balancing_scheme = ""

      # Use project NUMBER to prevent Terraform drift
      target_resources = ["projects/${data.google_project.project.number}/locations/us-central1/agentGateways/${google_network_services_agent_gateway.default.name}"]

      iap_enabled     = false
      extension_names = ["integrated-ext"]

      http_rules = [
        {
          when = null
          to = {
            operations = [
              {
                methods = []
                paths = [
                  {
                    exact = "/"
                  }
                ]
                # Include a dummy header to prevent empty-block drift
                header_set = [
                  {
                    headers = [
                      {
                        name = "x-test-header"
                        value = {
                          exact       = "test-value"
                          ignore_case = false
                        }
                      }
                    ]
                  }
                ]
              }
            ]
          }
        }
      ]
    }
  }
}
