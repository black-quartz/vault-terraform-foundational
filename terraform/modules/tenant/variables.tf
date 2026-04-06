variable "name" {
    description = "Name of the Vault tenant."
    type        = string
    nullable    = false
}

variable "auth_backends" {
    description = "Vault auth configuration options for the tenant."
    type = object({
        github = optional(object({
            enabled       = optional(bool, false)
            bound_claims  = map(string)
            token_ttl     = optional(number, 900)  # 15m
            token_max_ttl = optional(number, 1800) # 30m
        }), null)
        kubernetes = optional(object({
            enabled                          = optional(bool, false)
            bound_service_account_names      = set(string)
            bound_service_account_namespaces = set(string)
            token_ttl                        = optional(number, 28800) # 8hr
            token_max_ttl                    = optional(number, 86400) # 24hr
        }), null)
    })
    nullable = false
}

variable "secrets_engines" {
    description = "Vault secrets engine configuration options for the tenant."
    type = object({
        kubernetes = optional(object({
            enabled                       = optional(bool, false)
            name                          = string
            kubernetes_role_name          = string
            kubernetes_role_type          = string
            allowed_kubernetes_namespaces = list(string)
            token_default_ttl             = optional(number, 900)  # 15m
            token_max_ttl                 = optional(number, 1800) # 30m
        }), null)
        kv = optional(object({
            enabled = optional(bool, false)
            path    = string
        }), null)
    })
}

variable "github_auth_backend_path" {
    description = "Path for the GitHub JWT auth backend."
    type        = string
    default     = "jwt"
}

variable "kubernetes_auth_backend_path" {
    description = "Path for the Kubernetes auth backend."
    type        = string
    default     = "kubernetes"
}

variable "kubernetes_secrets_engine_path" {
    description = "Path for the Kubernetes secrets engine."
    type        = string
    default     = "kubernetes"
}

variable "kv_secrets_engine_path" {
    description = "Path for the KV v2 secrets engine."
    type        = string
    default     = "kv"
}
