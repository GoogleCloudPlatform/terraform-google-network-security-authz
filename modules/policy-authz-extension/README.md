### Integrated Module: `modules/integrated-authz/README.md`
Adapted from the original `terraform-google-policy-authz-extension` repository ([<img src="https://moma.corp.google.com/images/navstar.png" width=15 style="vertical-align:middle;"> source](https://github.com/vandnagarggoogle/terraform-google-policy-authz-extension/blob/main/README.md?content_ref=to+generated+module+detailed+this+module+was+generated+from+terraform+google+module+template)).

```markdown
# Google Cloud Integrated Authorization Policies and Extensions

This module creates both `google_network_security_authz_policy` and `google_network_services_authz_extension` resources in a coordinated manner. It handles many-to-many mappings and prevents duplication by allowing you to define maps of configurations for both extensions and policies.

## Usage

Basic usage of this module is as follows:

```hcl
module "policy_authz_extension" {
  source = "../../modules/integrated-authz"

  project_id = "your-gcp-project-id"
  location   = "us-central1"

  extensions_config = {
    "my-extension" = {
      authority             = "auth.example.com"
      backend_service       = "projects/your-gcp-project-id/global/backendServices/ext-svc"
      load_balancing_scheme = "INTERNAL_MANAGED"
    }
  }

  policies_config = {
    "my-policy" = {
      action                = "CUSTOM"
      load_balancing_scheme = "INTERNAL_MANAGED"
      target_resources      = ["projects/your-gcp-project-id/locations/us-central1/targetHttpProxies/proxy"]
      extension_names       = ["my-extension"]
    }
  }
}

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| extensions\_config | A map of unique Authz Extensions, indexed by their name. | <pre>map(object({<br>    authority             = string<br>    backend_service       = string<br>    load_balancing_scheme = string<br>    description           = optional(string, "Managed by ADC")<br>    timeout               = optional(string, "0.1s")<br>    fail_open             = optional(bool, false)<br>    forward_headers       = optional(list(string), [])<br>  }))</pre> | n/a | yes |
| location | n/a | `string` | n/a | yes |
| policies\_config | A map of Authz Policies with structured HTTP rules, indexed by name. | <pre>map(object({<br>    action                = string<br>    load_balancing_scheme = string<br>    target_resources      = list(string)<br>    description           = optional(string, "Managed by ADC")<br>    extension_names       = optional(list(string), [])<br>    iap_enabled           = optional(bool, false)<br>    http_rules = optional(list(object({<br>      when = optional(string)<br>      from = optional(object({<br>        not_sources = optional(list(object({<br>          ip_blocks = optional(list(object({<br>            prefix = string<br>            length = number<br>          })), [])<br>          principals = optional(list(object({<br>            principal_selector = optional(string, "CLIENT_CERT_URI_SAN")<br>            principal = optional(object({<br>              exact       = optional(string)<br>              ignore_case = optional(bool, true)<br>            }))<br>          })), [])<br>        })), [])<br>      }))<br>      to = optional(object({<br>        operations = optional(list(object({<br>          methods = optional(list(string), [])<br>          paths   = optional(list(object({ exact = string })), [])<br>          header_set = optional(list(object({<br>            headers = optional(list(object({<br>              name = string<br>              value = optional(object({<br>                exact       = string<br>                ignore_case = optional(bool, true)<br>              }))<br>            })), [])<br>          })), [])<br>        })), [])<br>      }))<br>    })), [])<br>  }))</pre> | n/a | yes |
| project\_id | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| extension\_ids | The fully qualified resource names designating the authorization extensions provisioned by the module. |
| policy\_extension\_map | A mapping of each authorization policy name to its designated authorization extension resource identifier. |
| policy\_ids | The fully qualified resource names designating the authorization policies provisioned by the module. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->