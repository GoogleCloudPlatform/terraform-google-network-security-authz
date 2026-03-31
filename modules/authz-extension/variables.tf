/**
 * Copyright 2026 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * ...
 */

variable "authority" {
  description = "The authority header of the gRPC request."
  type        = string
  default     = null
}

variable "description" {
  description = "A free-text description of the resource."
  type        = string
  default     = null
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "load_balancing_scheme" {
  description = "The load balancing scheme for which the AuthzExtension is applicable. Must be one of `INTERNAL_MANAGED` or `EXTERNAL_MANAGED`."
  type        = string
  default     = null
}

variable "location" {
  description = "The location of the AuthzExtension resource."
  type        = string
}

variable "name" {
  description = "The name of the AuthzExtension resource."
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs. If not provided, the provider project is used."
  type        = string
}

variable "service" {
  description = "The service that runs the extension (e.g., a BackendService URI or iap.googleapis.com)."
  type        = string
}

variable "timeout" {
  description = "Specifies the timeout for each individual message on the stream (between 10-10000ms). Format: '0.1s'."
  type        = string
}

variable "fail_open" {
  description = "Determines how the proxy behaves if the call to the extension fails. TRUE to continue, FALSE to error."
  type        = bool
  default     = false
}

variable "metadata" {
  description = "Metadata included as part of the ProcessingRequest message. Supports {forwarding_rule_id} substitution."
  type        = map(string)
  default     = {}
}

variable "forward_headers" {
  description = "List of HTTP headers to forward to the extension. If omitted, all headers are sent."
  type        = list(string)
  default     = null
}

variable "wire_format" {
  description = "The format of communication supported. Possible values: WIRE_FORMAT_UNSPECIFIED, EXT_PROC_GRPC, EXT_AUTHZ_GRPC."
  type        = string
  default     = null
}
