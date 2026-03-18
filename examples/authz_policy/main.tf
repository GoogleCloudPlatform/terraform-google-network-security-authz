data "google_project" "project" {
  project_id = var.project_id
}

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

# 2. Create a dummy Agent Gateway as a valid target (bypassing LB restrictions)
resource "google_network_services_agent_gateway" "default" {
  provider = google-beta
  name     = "authz-policy-target-ag"
  project  = var.project_id
  location = "us-central1"
  protocols = ["MCP"]
  
  google_managed {
    governed_access_path = "AGENT_TO_ANYWHERE"
  }
}

# 3. Call your Authz Policy module
module "authz_policy" {
  source = "../../modules/authz-policy"

  project_id = var.project_id
  name       = "simple-authz-policy"
  
  # CHANGE: Must match the Agent Gateway region
  location   = "us-central1" 
  action     = "ALLOW"
  policy_profile = "REQUEST_AUTHZ"


  http_rules = [
    {
      to = {
        operations = {
          paths = [
            {
              prefix = "/"
            }
          ]
          headers = [
            {
              name  = "x-test-header"
              exact = "test-value"
            }
          ]
        }
      }
    }
  ]

  target = {
    load_balancing_scheme = "" # Pass an empty string to override the default
    resources = ["projects/${data.google_project.project.number}/locations/us-central1/agentGateways/${google_network_services_agent_gateway.default.name}"]
  }

  labels = {
    environment = "test"
  }
}
