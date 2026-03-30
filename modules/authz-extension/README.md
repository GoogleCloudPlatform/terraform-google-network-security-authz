### Extension Module: `modules/authz-extension/README.md`
Adapted directly from the original `terraform-google-network-security-auth-extension` repository ([<img src="https://moma.corp.google.com/images/navstar.png" width=15 style="vertical-align:middle;"> source](https://github.com/Daisyprakash/terraform-google-network-security-auth-extension/blob/main/README.md?content_ref=here+is+a+basic+example+of+how+to+use+this+module+module+authz_extension+source+or+a+path+to+this+module)).

```markdown
# Google Cloud Network Services AuthzExtension

This module creates a `google_network_services_authz_extension` resource, which allows for flexible authorization policies in a service mesh or load balancer by integrating with an external gRPC authorizer. It is used to configure how traffic is authorized before it reaches a backend service.

## Usage

Here is a basic example of how to use this module:

```hcl
module "authz_extension" {
  source     = "../../modules/authz-extension"
  project_id = "your-gcp-project-id"
  name       = "my-custom-authz-extension"
  location   = "global"
  service    = "projects/your-gcp-project-id/global/backendServices/my-ext-authz-backend-service"
  authority  = "auth.example.com"
  timeout    = "5s"
  load_balancing_scheme = "INTERNAL_MANAGED"
  description = "Authorization extension for my service mesh."
  labels = {
    env = "production"
  }
}

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| authority | Required. The authority header of the gRPC request. | `string` | `"authz-ext.example.com"` | no |
| description | A free-text description of the resource. | `string` | `null` | no |
| fail\_open | Determines how the proxy behaves if the call to the extension fails. TRUE to continue, FALSE to error. | `bool` | `false` | no |
| forward\_headers | List of HTTP headers to forward to the extension. If omitted, all headers are sent. | `list(string)` | `null` | no |
| labels | A set of key/value label pairs to assign to the resource. | `map(string)` | `{}` | no |
| load\_balancing\_scheme | The load balancing scheme for which the AuthzExtension is applicable. Must be one of `INTERNAL_MANAGED` or `EXTERNAL_MANAGED`. | `string` | `"INTERNAL_MANAGED"` | no |
| location | The location of the AuthzExtension resource. | `string` | n/a | yes |
| metadata | Metadata included as part of the ProcessingRequest message. Supports {forwarding\_rule\_id} substitution. | `map(string)` | `{}` | no |
| name | The name of the AuthzExtension resource. | `string` | `"my-authz-extension"` | no |
| project\_id | The ID of the project in which the resource belongs. If not provided, the provider project is used. | `string` | n/a | yes |
| service | The service that runs the extension (e.g., a BackendService URI or iap.googleapis.com). | `string` | n/a | yes |
| timeout | Specifies the timeout for each individual message on the stream (between 10-10000ms). Format: '0.1s'. | `string` | `"10s"` | no |
| wire\_format | The format of communication supported. Possible values: WIRE\_FORMAT\_UNSPECIFIED, EXT\_PROC\_GRPC, EXT\_AUTHZ\_GRPC. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| create\_time | The timestamp when the resource was created. |
| effective\_labels | All labels present on the resource in GCP, including those from Terraform and other sources. |
| id | The fully qualified identifier of the AuthzExtension resource. |
| name | The name of the created AuthzExtension resource. |
| terraform\_labels | The combination of labels configured directly on the resource and default provider labels. |
| update\_time | The timestamp when the resource was last updated. |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| authority | Required. The authority header of the gRPC request. | `string` | n/a | yes |
| description | A free-text description of the resource. | `string` | `null` | no |
| fail\_open | Determines how the proxy behaves if the call to the extension fails. TRUE to continue, FALSE to error. | `bool` | n/a | yes |
| forward\_headers | List of HTTP headers to forward to the extension. If omitted, all headers are sent. | `list(string)` | `null` | no |
| labels | A set of key/value label pairs to assign to the resource. | `map(string)` | `{}` | no |
| load\_balancing\_scheme | The load balancing scheme for which the AuthzExtension is applicable. Must be one of `INTERNAL_MANAGED` or `EXTERNAL_MANAGED`. | `string` | n/a | yes |
| location | The location of the AuthzExtension resource. | `string` | n/a | yes |
| metadata | Metadata included as part of the ProcessingRequest message. Supports {forwarding\_rule\_id} substitution. | `map(string)` | `{}` | no |
| name | The name of the AuthzExtension resource. | `string` | n/a | yes |
| project\_id | The ID of the project in which the resource belongs. If not provided, the provider project is used. | `string` | n/a | yes |
| service | The service that runs the extension (e.g., a BackendService URI or iap.googleapis.com). | `string` | n/a | yes |
| timeout | Specifies the timeout for each individual message on the stream (between 10-10000ms). Format: '0.1s'. | `string` | n/a | yes |
| wire\_format | The format of communication supported. Possible values: WIRE\_FORMAT\_UNSPECIFIED, EXT\_PROC\_GRPC, EXT\_AUTHZ\_GRPC. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| create\_time | The timestamp when the resource was created. |
| effective\_labels | All labels present on the resource in GCP, including those from Terraform and other sources. |
| id | The fully qualified identifier of the AuthzExtension resource. |
| name | The name of the created AuthzExtension resource. |
| terraform\_labels | The combination of labels configured directly on the resource and default provider labels. |
| update\_time | The timestamp when the resource was last updated. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
